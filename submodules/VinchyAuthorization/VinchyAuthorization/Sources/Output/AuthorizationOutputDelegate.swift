//
//  AuthorizationOutputDelegate.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 06.02.2021.
//

import Foundation

public struct AythorizationOutputModel {
  public let email: String
}

public protocol AuthorizationOutputDelegate: AnyObject {
  func didSuccessfullyRegister(output: AythorizationOutputModel?)
  func didSuccessfullyLogin(output: AythorizationOutputModel?)
}
