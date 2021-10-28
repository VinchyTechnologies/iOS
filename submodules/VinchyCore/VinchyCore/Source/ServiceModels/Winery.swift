//
//  Winery.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 04.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public final class Winery: Decodable, Equatable {

  // MARK: Public

  /// Winery ID
  public let id: Int64

  /// Name of the winery
  public let title: String?

  /// Country code of the winery locates in
  public let countryCode: String?

  /// Name of the region the winery locates in
  public let region: String?

  public static func == (lhs: Winery, rhs: Winery) -> Bool {
    lhs.id == rhs.id
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case id = "winery_id"
    case title
    case countryCode = "country_code"
    case region
  }

  /// For tests only
  /*
    public init(countryCode: String) {
      self.id = 0
      self.title = ""
      self.countryCode = countryCode
      self.region = ""
    }
   */
}
