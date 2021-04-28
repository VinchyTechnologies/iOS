//
//  MapInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import MapKit
import VinchyCore

fileprivate enum C {
  static let defaultRadius: Double = 200
}

final class MapInteractor {
  
  private let repository: MapRepositoryProtocol
  private let router: MapRouterProtocol
  private let presenter: MapPresenterProtocol
  
  private var partnersOnMap: [PartnerOnMap] = []
  
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
    repository.requestPartners(userLocation: position, radius: Int(mapView.currentRadius())) { [weak self] result in
      switch result {
      case .success(let partnersOnMap):
        self?.partnersOnMap = partnersOnMap
        self?.presenter.didReceive(partnersOnMap: partnersOnMap)
        
      case .failure(let error):
        print("=== error", error)
      }
    }
  }
  
  func viewDidLoad() {
    repository.requestUserLocation { userLocation in
      if let userLocation = userLocation {
        self.presenter.updateUserLocationAndRegion(userLocation, radius: C.defaultRadius)
      }
      
      self.repository.requestPartners(userLocation: userLocation, radius: Int(C.defaultRadius)) { [weak self] result in
        switch result {
        case .success(let partnersOnMap):
          self?.partnersOnMap = partnersOnMap
          self?.presenter.didReceive(partnersOnMap: partnersOnMap)
          
        case .failure(let error):
          print("=== error", error)
        }
      }
    }
    
  }
}

fileprivate extension MKMapView {
  
  func topCenterCoordinate() -> CLLocationCoordinate2D {
    self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
  }
  
  func currentRadius() -> Double {
    let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
    let topCenterCoordinate = self.topCenterCoordinate()
    let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
    return centerLocation.distance(from: topCenterLocation)
  }
}
