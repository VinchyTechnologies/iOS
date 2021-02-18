//
//  AccountInfo.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 06.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

public struct AccountInfo: Decodable {
  
  public let accountID: Int64
  public let email: String
  public let accessToken: String
  public let refreshToken: String
  
  private enum CodingKeys: String, CodingKey {
    case accountID = "account_id"
    case email
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
  }
  
}
