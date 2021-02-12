//
//  AuthorizationRouterProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Foundation

protocol AuthorizationRouterProtocol: AnyObject {
  func pushToEnterPasswordViewController(accountID: Int)
  func dismissWithSuccsessLogin(output: AuthorizationOutputModel?)
}
