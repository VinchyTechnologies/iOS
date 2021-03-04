//
//  AuthorizationOutputDelegate.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 06.02.2021.
//

import VinchyCore

public struct AuthorizationOutputModel {
  public let accountID: Int
  public let email: String
}

public protocol AuthorizationOutputDelegate: AnyObject {
  func didSuccessfullyRegister(output: AuthorizationOutputModel?)
  func didSuccessfullyLogin(output: AuthorizationOutputModel?)
}
