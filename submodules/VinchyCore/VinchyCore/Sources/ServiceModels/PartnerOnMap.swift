//
//  PartnerOnMap.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 27.04.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public struct PartnerOnMap: Decodable, Hashable {
  public let id: Int
  public let affiliatedStores: [AffiliatedStore]

  private enum CodingKeys: String, CodingKey {
    case id = "partner_id"
    case affiliatedStores = "affiliated_stores"
  }
}
