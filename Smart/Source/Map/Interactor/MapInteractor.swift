//
//  MapInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import MapKit
import VinchyCore

// MARK: - C

private enum C {
  static let defaultRadius: Double = 2000
}

// MARK: - MapState

private enum MapState {
  case normal, routing
}

// MARK: - MapInteractor

final class MapInteractor {

  // MARK: Lifecycle

  init(
    repository: MapRepositoryProtocol,
    router: MapRouterProtocol,
    presenter: MapPresenterProtocol)
  {
    self.repository = repository
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let repository: MapRepositoryProtocol
  private let router: MapRouterProtocol
  private let presenter: MapPresenterProtocol
  private var throttler: Throttler?
  private var partnersOnMap = Set<PartnerOnMap>()
  private var currentRadius = C.defaultRadius
  private var currentPosition: CLLocationCoordinate2D?
  private var mapState = MapState.normal

  private func processMove(
    to position: CLLocationCoordinate2D,
    mapVisibleRegion _: MKMapRect,
    mapView: MKMapView,
    label: String?)
  {
    let radius = mapView.currentRadius()
    if let currentPosition = self.currentPosition {
      let distance = CLLocation.distance(from: currentPosition, to: position)
      if distance + Double(radius) <= currentRadius {
        self.currentPosition = position
        currentRadius = radius
        return
      }
    }

    repository.requestPartners(userLocation: position, radius: Int(mapView.currentRadius())) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let partnersOnMap):
        self.partnersOnMap = Set<PartnerOnMap>(partnersOnMap)
        if self.throttler?.label == label {
          self.presenter.didReceive(partnersOnMap: self.partnersOnMap, userLocation: position)
        }

      case .failure(let error):
        self.presenter.showAlert(error: error)
      }
    }
    currentPosition = position
    currentRadius = radius
  }
}

// MARK: MapInteractorProtocol

extension MapInteractor: MapInteractorProtocol {
  func didTapSearchThisAreaButton(
    position: CLLocationCoordinate2D,
    radius: Double)
  {
    repository.requestPartners(userLocation: position, radius: Int(radius)) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let partnersOnMap):
        self.partnersOnMap = Set<PartnerOnMap>(partnersOnMap)
        self.presenter.didReceive(partnersOnMap: self.partnersOnMap, userLocation: position)

      case .failure(let error):
        self.presenter.showAlert(error: error)
      }
    }
  }

  func didTapXMarkButtonOnRoutingToolBar() {
    mapState = .normal
    presenter.deselectSelectedPin()
    presenter.removeAllOverlays()
  }

  func didTapAssortmentButton(partnerId: Int, affilatedId: Int, title: String?) {
    router.showAssortmentViewController(partnerId: partnerId, affilatedId: affilatedId, title: title)
  }

  func requestBottomSheetDismissToDeselectSelectedPin() {
    if mapState == .normal {
      presenter.deselectSelectedPin()
    }
  }

  func didTapShowRouteOnBottomSheet(coordinate: CLLocationCoordinate2D) {
    mapState = .routing
    let currentPlacemark = MKPlacemark(coordinate: coordinate)
    let directionRequest = MKDirections.Request()
    let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)

    directionRequest.source = MKMapItem.forCurrentLocation()
    directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
    directionRequest.transportType = .walking

    let directions = MKDirections(request: directionRequest)
    directions.calculate { directionsResponse, error in
      guard let directionsResponse = directionsResponse else {
        if let error = error {
          self.router.dismissCurrentBottomSheet(shouldUseDidDismissCallback: true)
          self.presenter.showAlert(error: error)
        }
        return
      }

      if let route = directionsResponse.routes.first {
        self.router.dismissCurrentBottomSheet(shouldUseDidDismissCallback: false)
        self.presenter.didReceive(route: route)
      } else {
        self.router.dismissCurrentBottomSheet(shouldUseDidDismissCallback: true)
        self.presenter.showAlert(error: NSError(domain: "No routes", code: 1, userInfo: [:]))
      }
    }
  }

  func didTapOnPin(partnerId: Int, affilatedId: Int) {
    router.showMapDetailStore(partnerId: partnerId, affilatedId: affilatedId)
  }

  func didMove(
    to position: CLLocationCoordinate2D,
    mapVisibleRegion: MKMapRect,
    mapView: MKMapView,
    shouldUseThrottler: Bool)
  {
    guard mapState == .normal else { return }
    throttler?.cancel()
    if shouldUseThrottler {
      let uuid = UUID().uuidString
      throttler = Throttler()
      throttler?.label = uuid
      throttler?.throttle(delay: .milliseconds(1250)) {
        self.processMove(to: position, mapVisibleRegion: mapVisibleRegion, mapView: mapView, label: uuid)
      }
    } else {
      processMove(to: position, mapVisibleRegion: mapVisibleRegion, mapView: mapView, label: nil)
    }
  }

  func viewDidLoad() {

    if UserDefaultsConfig.shouldUseCurrentGeo {
      repository.requestUserLocation { userLocation in
        if let userLocation = userLocation {
          self.presenter.updateUserLocationAndRegion(userLocation, radius: C.defaultRadius)
        }

        self.repository.requestPartners(userLocation: userLocation, radius: Int(C.defaultRadius)) { [weak self] result in
          guard let self = self else { return }
          switch result {
          case .success(let partnersOnMap):
            self.partnersOnMap = Set<PartnerOnMap>(partnersOnMap)
            self.presenter.didReceive(partnersOnMap: self.partnersOnMap, userLocation: userLocation)

          case .failure(let error):
            self.presenter.showAlert(error: error)
          }
        }
      }
    } else if UserDefaultsConfig.userLatitude != 0 && UserDefaultsConfig.userLongtitude != 0 {
      repository.requestPartners(userLocation: CLLocationCoordinate2D(latitude: UserDefaultsConfig.userLatitude, longitude: UserDefaultsConfig.userLongtitude), radius: Int(C.defaultRadius)) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let partnersOnMap):
          self.partnersOnMap = Set<PartnerOnMap>(partnersOnMap)
          self.presenter.didReceive(partnersOnMap: self.partnersOnMap, userLocation: CLLocationCoordinate2D(latitude: UserDefaultsConfig.userLatitude, longitude: UserDefaultsConfig.userLongtitude))

        case .failure(let error):
          self.presenter.showAlert(error: error)
        }
      }
    } else {
      repository.requestPartners(userLocation: CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423), radius: Int(C.defaultRadius)) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let partnersOnMap):
          self.partnersOnMap = Set<PartnerOnMap>(partnersOnMap)
          self.presenter.didReceive(partnersOnMap: self.partnersOnMap, userLocation: CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423))
          self.presenter.updateUserLocationAndRegion(CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423), radius: C.defaultRadius)

        case .failure(let error):
          self.presenter.showAlert(error: error)
        }
      }
    }
  }
}

extension MKMapView {
  func topCenterCoordinate() -> CLLocationCoordinate2D {
    convert(CGPoint(x: frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
  }

  func currentRadius() -> Double {
    let centerLocation = CLLocation(
      latitude: centerCoordinate.latitude,
      longitude: centerCoordinate.longitude)
    let topCenterCoordinate = self.topCenterCoordinate()
    let topCenterLocation = CLLocation(
      latitude: topCenterCoordinate.latitude,
      longitude: topCenterCoordinate.longitude)
    return centerLocation.distance(from: topCenterLocation)
  }
}

extension CLLocation {
  /// Get distance between two points
  ///
  /// - Parameters:
  ///   - from: first point
  ///   - to: second point
  /// - Returns: the distance in meters
  class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
    let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
    let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
    return from.distance(from: to)
  }
}
