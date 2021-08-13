//
//  PartnerInfo.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 07.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - PartnerInfo

public struct PartnerInfo: Decodable {

  // MARK: Public

  public let affiliatedStoreId: Int
  public let title: String
  public let latitude: Double?
  public let longitude: Double?
  public let affiliatedStoreType: AffiliatedStoreType?
  public let url: String?
  public let phoneNumber: String?
  public let scheduleOfWork: String?
  public let address: String?
  public let logoURL: String?

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case affiliatedStoreId = "affiliated_store_id"
    case title
    case latitude
    case longitude
    case affiliatedStoreType = "affiliated_store_type"
    case url
    case phoneNumber = "phone_number"
    case scheduleOfWork = "schedule_of_work"
    case address
    case logoURL = "logo_url"
  }
}

// MARK: - AffiliatedStoreType

public struct AffiliatedStoreType: Decodable {
  public let affiliatedStoreTypeId: Int
  public let title: String

  private enum CodingKeys: String, CodingKey {
    case affiliatedStoreTypeId = "affiliated_store_type_id"
    case title
  }
}
