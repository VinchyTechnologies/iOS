//
//  PartnerInfo.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 07.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - PartnerInfo

public struct PartnerInfo: Decodable, Equatable {

  // MARK: Lifecycle

  public init(
    affiliatedStoreId: Int,
    title: String,
    latitude: Double?,
    longitude: Double?,
    affiliatedStoreType: AffiliatedStoreType?,
    url: String?,
    phoneNumber: String?,
    scheduleOfWork: String?,
    address: String?,
    logoURL: String?,
    preferredCurrencyCode: String?)
  {
    self.affiliatedStoreId = affiliatedStoreId
    self.title = title
    self.latitude = latitude
    self.longitude = longitude
    self.affiliatedStoreType = affiliatedStoreType
    self.url = url
    self.phoneNumber = phoneNumber
    self.scheduleOfWork = scheduleOfWork
    self.address = address
    self.logoURL = logoURL
    self.preferredCurrencyCode = preferredCurrencyCode
  }

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
  public let preferredCurrencyCode: String?

  public static func == (lhs: PartnerInfo, rhs: PartnerInfo) -> Bool {
    lhs.affiliatedStoreId == rhs.affiliatedStoreId
  }

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
    case preferredCurrencyCode = "preferred_currency_code"
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
