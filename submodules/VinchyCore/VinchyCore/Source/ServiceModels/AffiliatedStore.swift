//
//  AffiliatedStore.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 27.04.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public struct AffiliatedStore: Decodable, Hashable {
  
  public let id: Int
  public let title: String
  public let latitude: Double
  public let longitude: Double
  
  private enum CodingKeys: String, CodingKey {
    case id = "affiliated_store_id"
    case title
    case latitude
    case longitude
  }
}
