//
//  VinchyRepositoryProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import MapKit
import VinchyCore

protocol VinchyRepositoryProtocol: AnyObject {

  func requestUserLocation(
    completion: @escaping (CLLocationCoordinate2D?) -> Void)

  func requestNearestPartners(
    userLocation: CLLocationCoordinate2D?,
    radius: Int,
    completion: @escaping (Result<[NearestPartner], Error>) -> Void)
}
