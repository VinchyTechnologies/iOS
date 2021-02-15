//
//  AuthorizationInput.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Foundation

struct AuthorizationInput {
  
  enum AuthorizationMode {
    case register, login
  }
  
  let mode: AuthorizationMode
}
