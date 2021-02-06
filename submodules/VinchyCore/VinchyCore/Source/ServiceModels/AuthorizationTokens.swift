//
//  AuthorizationTokens.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 06.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

public struct AuthorizationTokens: Decodable {
  
  public let accessToken: String
  public let refreshToken: String
  
  private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
  }
  
}
