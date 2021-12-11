//
//  Review.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public struct Review: Decodable {
  public let id: Int
  public let accountID: Int64
  public let rating: Double
  public let comment: String?
  public let publicationDate: String
  public let updateDate: String?

  private enum CodingKeys: String, CodingKey {
    case id = "review_id"
    case accountID = "account_id"
    case rating
    case comment
    case publicationDate = "publication_date"
    case updateDate = "update_date"
  }
}
