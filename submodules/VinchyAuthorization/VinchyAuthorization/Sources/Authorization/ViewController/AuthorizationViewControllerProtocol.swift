//
//  AuthorizationViewControllerProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Foundation

protocol AuthorizationViewControllerProtocol: AnyObject {
  func updateUI(viewModel: AuthorizationViewModel)
  func updateUIInvalidEmail()
  func updateUIValidEmail()
}
