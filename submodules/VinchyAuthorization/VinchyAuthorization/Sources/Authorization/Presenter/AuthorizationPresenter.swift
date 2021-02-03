//
//  AuthorizationPresenter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import StringFormatting

final class AuthorizationPresenter {
  
  private typealias ViewModel = AuthorizationViewModel
  
  weak var viewController: AuthorizationViewControllerProtocol?
  
  init(viewController: AuthorizationViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - AuthorizationPresenterProtocol

extension AuthorizationPresenter: AuthorizationPresenterProtocol {
  
  func endEditing() {
    viewController?.endEditing()
  }
  
  func showCreateUserError(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }
  
  func update() {
    let viewModel = AuthorizationViewModel(
      titleText: "Welcome",
      subtitleText: "To start collect bottles your should authentificate yourself",
      emailTextFiledPlaceholderText: "Enter Email",
      emailTextFiledTopPlaceholderText: "Email",
      passwordTextFiledPlaceholderText: "Password",
      passwordTextFiledTopPlaceholderText: "Password",
      continueButtonText: "Next")
    
    viewController?.updateUI(viewModel: viewModel)
  }
  
  func updateValidEmailAndPassword() {
    viewController?.updateUIValidEmailAndPassword()
  }
  
  func updateInvalidEmailAndPassword() {
    viewController?.updateUIInvalidEmailAndPassword()
  }
}
