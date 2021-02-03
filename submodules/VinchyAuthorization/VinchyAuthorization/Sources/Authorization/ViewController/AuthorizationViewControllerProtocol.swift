//
//  AuthorizationViewControllerProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Display

protocol AuthorizationViewControllerProtocol: Alertable {
  func updateUI(viewModel: AuthorizationViewModel)
  func updateUIInvalidEmailAndPassword()
  func updateUIValidEmailAndPassword()
  func endEditing()
}
