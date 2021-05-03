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

fileprivate enum C {
  static let defaultRadius: Double = 200
}

final class MapInteractor {
  
  private let repository: MapRepositoryProtocol
  private let router: MapRouterProtocol
  private let presenter: MapPresenterProtocol
  private let throttler = Throttler()
  private var partnersOnMap: Set<PartnerOnMap> = Set<PartnerOnMap>() 
  private var currentRadius = C.defaultRadius
  private var currentPosition: CLLocationCoordinate2D?
  
  init(
    repository: MapRepositoryProtocol,
    router: MapRouterProtocol,
    presenter: MapPresenterProtocol)
  {
    self.repository = repository
    self.router = router
    self.presenter = presenter
  }
}

// MARK: - MapInteractorProtocol

extension MapInteractor: MapInteractorProtocol {
  
  func didMove(
    to position: CLLocationCoordinate2D,
    mapVisibleRegion: MKMapRect,
    mapView: MKMapView)
  {
    
    let radius = mapView.currentRadius()
    
    throttler.cancel()
    throttler.throttle(delay: .milliseconds(1250)) {
      
      if let currentPosition = self.currentPosition {
        let distance = CLLocation.distance(from: currentPosition, to: position)
        if distance + Double(radius) <= self.currentRadius {
          self.currentPosition = position
          self.currentRadius = radius
          return
        }
      }
      
      self.repository.requestPartners(userLocation: position, radius: Int(mapView.currentRadius())) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let partnersOnMap):
          self.partnersOnMap = Set<PartnerOnMap>(partnersOnMap)
          self.presenter.didReceive(partnersOnMap: self.partnersOnMap)
          
        case .failure(let error):
          print("=== error", error)
        }
      }
      self.currentPosition = position
      self.currentRadius = radius
    }
  }
  
  func viewDidLoad() {
    repository.requestUserLocation { userLocation in
      if let userLocation = userLocation {
        self.presenter.updateUserLocationAndRegion(userLocation, radius: C.defaultRadius)
      }
      
      self.repository.requestPartners(userLocation: userLocation, radius: Int(C.defaultRadius)) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let partnersOnMap):
          self.partnersOnMap = Set<PartnerOnMap>(partnersOnMap)
          self.presenter.didReceive(partnersOnMap: self.partnersOnMap)
          
        case .failure(let error):
          print("=== error", error)
        }
      }
    }
  }
}

fileprivate extension MKMapView {
  
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

fileprivate extension CLLocation {
    
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
