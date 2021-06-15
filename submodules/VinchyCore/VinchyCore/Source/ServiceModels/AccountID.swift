//
//  AccountID.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 31.01.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public struct AccountID: Decodable {
  public let accountID: Int

  private enum CodingKeys: String, CodingKey {
    case accountID = "account_id"
  }
}
