//
//  UpdateTokensResponse.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 23.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public struct UpdateTokensResponse: Decodable {
  public let accessToken: String
  public let refreshToken: String

  private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
  }
}
