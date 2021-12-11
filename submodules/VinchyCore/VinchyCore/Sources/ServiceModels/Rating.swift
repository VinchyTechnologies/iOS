//
//  Rating.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 20.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

public struct Rating: Decodable {
  public let rating: Double?
  public let reviewsCount: Int?

  private enum CodingKeys: String, CodingKey {
    case rating
    case reviewsCount = "reviews_count"
  }
}
