//
//  MapViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreLocation
import VinchyCore
import MapKit
import Display

protocol MapViewControllerProtocol: Alertable {
  func setUserLocation(_ userLocation: CLLocationCoordinate2D, radius: Double)
  func updateUI(viewModel: MapViewModel)
  func updateUI(newPartnersOnMap: [PartnerAnnotationViewModel])
  func drawRoute(route: MKRoute)
  func deselectSelectedPin()
  func setRoutingToolBarHidden(_ flag: Bool)
  func removeAllOverlays()
}
