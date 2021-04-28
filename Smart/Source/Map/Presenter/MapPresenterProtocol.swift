//
//  MapPresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreLocation
import VinchyCore

protocol MapPresenterProtocol: AnyObject {
  func updateUserLocationAndRegion(_ userLocation: CLLocationCoordinate2D, radius: Double)
  func didReceive(partnersOnMap: [PartnerOnMap])
}
