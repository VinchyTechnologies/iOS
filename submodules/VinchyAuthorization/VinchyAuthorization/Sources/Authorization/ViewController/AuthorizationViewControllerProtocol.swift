//
//  AuthorizationViewControllerProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import DisplayMini

protocol AuthorizationViewControllerProtocol: Alertable, Loadable {
  func updateUI(viewModel: AuthorizationViewModel)
  func updateUIInvalidEmailAndPassword()
  func updateUIValidEmailAndPassword()
  func endEditing()
}
