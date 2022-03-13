//
//  AvailableFilters.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 13.03.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import Foundation

public struct AvailableFilters: Decodable {
  public let isPriceAvailable: Bool

  private enum CodingKeys: String, CodingKey {
    case isPriceAvailable = "is_price_available"
  }
}
