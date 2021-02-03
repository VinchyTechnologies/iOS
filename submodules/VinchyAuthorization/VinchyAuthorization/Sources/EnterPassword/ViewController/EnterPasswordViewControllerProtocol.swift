//
//  EnterPasswordViewControllerProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import Display

protocol EnterPasswordViewControllerProtocol: Alertable {
  func updateUI(viewModel: EnterPasswordViewModel)
  func updateUI(buttonText: String, isButtonEnabled: Bool)
}
