//
//  ChooseAuthTypeRouterProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import Foundation

protocol ChooseAuthTypeRouterProtocol: AnyObject {
  func pushAuthorizationViewController(mode: AuthorizationInput.AuthorizationMode)
}
