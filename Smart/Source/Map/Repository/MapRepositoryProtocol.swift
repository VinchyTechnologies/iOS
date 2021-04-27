//
//  MapRepositoryProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreLocation
import VinchyCore

protocol MapRepositoryProtocol {
    
  func requestPartners(
    userLocation: CLLocationCoordinate2D?,
    radius: Int,
    completion: @escaping (Result<[PartnerOnMap], Error>) -> Void)
  
  func requestUserLocation(
    completion: @escaping (CLLocationCoordinate2D?) -> Void)
}
