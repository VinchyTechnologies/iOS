//
//  AuthorizationPresenter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Foundation

final class AuthorizationPresenter {
  
  private typealias ViewModel = AuthorizationViewModel
  
  weak var viewController: AuthorizationViewControllerProtocol?
  
  init(viewController: AuthorizationViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - AuthorizationPresenterProtocol

extension AuthorizationPresenter: AuthorizationPresenterProtocol {
  func update() {
    
    let viewModel = AuthorizationViewModel(
      titleText: "Welcome",
      subtitleText: "To start collect bottles your should authentificate yourself",
      emailTextFiledPlaceholderText: "Enter Email",
      emailTextFiledTopPlaceholderText: "Email",
      continueButtonText: "Next")
    
    viewController?.updateUI(viewModel: viewModel)
  }
  
  func updateValidEmail() {
    viewController?.updateUIValidEmail()
  }
  
  func updateInvalidEmail() {
    viewController?.updateUIInvalidEmail()
  }
}
