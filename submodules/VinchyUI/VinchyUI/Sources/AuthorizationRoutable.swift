//
//  AuthorizationRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 05.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - AuthorizationRoutable

public protocol AuthorizationRoutable: AnyObject {
  func presentAuthorizationViewController()
}

// MARK: - AuthorizationOutputModel

public struct AuthorizationOutputModel {
  public let accountID: Int
  public let email: String

  public init(accountID: Int, email: String) {
    self.accountID = accountID
    self.email = email
  }
}

// MARK: - AuthorizationOutputDelegate

public protocol AuthorizationOutputDelegate: AnyObject {
  func didSuccessfullyRegister(output: AuthorizationOutputModel?)
  func didSuccessfullyLogin(output: AuthorizationOutputModel?)
}
