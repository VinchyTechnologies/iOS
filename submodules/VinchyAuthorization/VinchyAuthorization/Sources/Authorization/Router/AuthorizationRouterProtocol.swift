//
//  AuthorizationRouterProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import VinchyUI

protocol AuthorizationRouterProtocol: AnyObject {
  func pushToEnterPasswordViewController(accountID: Int, password: String)
  func dismissWithSuccsessLogin(output: AuthorizationOutputModel?)
}
