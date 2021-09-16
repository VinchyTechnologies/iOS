//
//  NearestPartner.swift
//  VinchyCore
//
//  Created by Михаил Исаченко on 12.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - NearestPartner

public struct NearestPartner: Decodable {
  public let partner: Partner
  public let recommendedWines: [Wine]
  private enum CodingKeys: String, CodingKey {
    case recommendedWines = "recommended_wines"
    case partner
  }
}

// MARK: - Partner

public struct Partner: Decodable {
  public let partnerID: Int
  public let title: String
  public let url: String
  public let logoURL: String
  public let affiliatedStores: [PartnerInfo]

  private enum CodingKeys: String, CodingKey {
    case partnerID = "partner_id"
    case title
    case url
    case logoURL = "logo_url"
    case affiliatedStores = "affiliated_stores"
  }
}

// MARK: - PartnerWine

public struct PartnerWine: Decodable {
  public let partnerWineID: Int
  public let url: String

  private enum CodingKeys: String, CodingKey {
    case partnerWineID = "partner_wine_id"
    case url
  }
}
