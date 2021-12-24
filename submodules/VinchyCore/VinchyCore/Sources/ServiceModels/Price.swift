//
//  Price.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 24.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public struct Price: Decodable, Equatable {
  public let amount: Int64
  public let currencyCode: String

  private enum CodingKeys: String, CodingKey {
    case amount = "amount"
    case currencyCode = "currency_code"
  }
}
