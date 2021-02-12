//
//  EnterPasswordRouterProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import VinchyCore

protocol EnterPasswordRouterProtocol: AnyObject {
  func dismissAndRequestSuccess(output: AuthorizationOutputModel?)
}
