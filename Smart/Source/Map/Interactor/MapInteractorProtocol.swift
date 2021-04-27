//
//  MapInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import MapKit

protocol MapInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didMove(to position: CLLocationCoordinate2D, mapVisibleRegion: MKMapRect, mapView: MKMapView)
}
