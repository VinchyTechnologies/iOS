//
//  MapRepositoryProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreLocation

protocol MapRepositoryProtocol {
    
  func requestPartners(
    userLocation: CLLocationCoordinate2D?,
    completion: @escaping (Result<[Any], Error>) -> Void)
  
  func requestUserLocation(
    completion: @escaping (CLLocationCoordinate2D?) -> Void)
  
  //    func requestPartnersDefaultLocation(request: Weather.RequestDefault, completion: @escaping (Result<Weather.Response, Weather.Error>) -> Void)
}
