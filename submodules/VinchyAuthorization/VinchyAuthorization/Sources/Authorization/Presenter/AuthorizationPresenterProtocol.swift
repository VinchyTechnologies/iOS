//
//  AuthorizationPresenterProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Foundation

protocol AuthorizationPresenterProtocol: AnyObject {
  func update()
  func updateValidEmailAndPassword()
  func updateInvalidEmailAndPassword()
  func showCreateUserError(error: Error)
  func endEditing()
  func showLoginUserError(error: Error)
  func startLoading()
  func stopLoading()
}
