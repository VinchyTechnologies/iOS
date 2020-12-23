//
//  EnterPasswordPresenter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import Foundation

final class EnterPasswordPresenter {
    
  weak var viewController: EnterPasswordViewControllerProtocol?
  
  init(viewController: EnterPasswordViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - EnterPasswordPresenterProtocol

extension EnterPasswordPresenter: EnterPasswordPresenterProtocol {
  
  func update() {
    let viewModel = EnterPasswordViewModel(
      titleText: nil,//"Glad to see you again",
      subtitleText: "Enter code received in email",
      enterPasswordTextFiledPlaceholderText: "Enter code",
      enterPasswordTextFiledTopPlaceholderText: "Code",
      continueButtonText: "Confirm",
      rightBarButtonItemText: "Send code again")
    
    viewController?.updateUI(viewModel: viewModel)
  }
}
