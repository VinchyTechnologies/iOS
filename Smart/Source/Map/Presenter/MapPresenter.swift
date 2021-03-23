//
//  MapPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreLocation

final class MapPresenter {
  
  private typealias ViewModel = MapViewModel
  
  weak var viewController: MapViewControllerProtocol?
  
  init(viewController: MapViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - MapPresenterProtocol

extension MapPresenter: MapPresenterProtocol {
  func updateUserLocationAndRegion(_ userLocation: CLLocationCoordinate2D, radius: Double) {
    viewController?.setUserLocation(userLocation, radius: radius)
  }
}
