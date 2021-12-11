//
//  NearestPartner.swift
//  VinchyCore
//
//  Created by Михаил Исаченко on 12.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - NearestPartner

public struct NearestPartner: Decodable {
  public let partner: PartnerInfo
  public let recommendedWines: [ShortWine]

  private enum CodingKeys: String, CodingKey {
    case recommendedWines = "recommended_wines"
    case partner = "affiliated_store"
  }
}
