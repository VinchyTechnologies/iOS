//
//  AuthorizationOutputDelegate.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 06.02.2021.
//

import VinchyCore

// MARK: - AuthorizationOutputModel

public struct AuthorizationOutputModel {
  public let accountID: Int
  public let email: String
}

// MARK: - AuthorizationOutputDelegate

public protocol AuthorizationOutputDelegate: AnyObject {
  func didSuccessfullyRegister(output: AuthorizationOutputModel?)
  func didSuccessfullyLogin(output: AuthorizationOutputModel?)
}
