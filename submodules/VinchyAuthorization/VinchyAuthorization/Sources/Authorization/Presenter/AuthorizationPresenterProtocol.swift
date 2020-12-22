//
//  AuthorizationPresenterProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Foundation

protocol AuthorizationPresenterProtocol: AnyObject {
  func update()
  func updateValidEmail()
  func updateInvalidEmail()
}
