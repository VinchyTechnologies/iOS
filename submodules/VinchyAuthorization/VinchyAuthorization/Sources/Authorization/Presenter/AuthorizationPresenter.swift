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
  private let input: AuthorizationInput
  
  init(input: AuthorizationInput, viewController: AuthorizationViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - AuthorizationPresenterProtocol

extension AuthorizationPresenter: AuthorizationPresenterProtocol {
  
  func startLoading() {
    viewController?.startLoadingAnimation()
    viewController?.addLoader()
  }
  
  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }
  
  func endEditing() {
    viewController?.endEditing()
  }
  
  func showCreateUserError(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }
  
  func showLoginUserError(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }
  
  func update() {
    let viewModel: AuthorizationViewModel
    switch input.mode {
    case .register:
      viewModel = AuthorizationViewModel(
        titleText: localized("register", bundle: Bundle(for: type(of: self))).firstLetterUppercased(),
        subtitleText: localized("register_subtitle", bundle: Bundle(for: type(of: self))),
        emailTextFiledPlaceholderText: localized("enter_email", bundle: Bundle(for: type(of: self))),
        emailTextFiledTopPlaceholderText: localized("email", bundle: Bundle(for: type(of: self))).firstLetterUppercased(),
        passwordTextFiledPlaceholderText: localized("enter_password", bundle: Bundle(for: type(of: self))).firstLetterUppercased(),
        passwordTextFiledTopPlaceholderText: localized("password", bundle: Bundle(for: type(of: self))).firstLetterUppercased(),
        continueButtonText: localized("next", bundle: Bundle(for: type(of: self))).firstLetterUppercased())
      
    case .login:
      viewModel = AuthorizationViewModel(
        titleText: localized("sign_in", bundle: Bundle(for: type(of: self))).firstLetterUppercased(),
        subtitleText: localized("sign_in_subtitle", bundle: Bundle(for: type(of: self))), 
        emailTextFiledPlaceholderText: localized("enter_email", bundle: Bundle(for: type(of: self))),
        emailTextFiledTopPlaceholderText: localized("email", bundle: Bundle(for: type(of: self))).firstLetterUppercased(),
        passwordTextFiledPlaceholderText: localized("enter_password", bundle: Bundle(for: type(of: self))).firstLetterUppercased(),
        passwordTextFiledTopPlaceholderText: localized("password", bundle: Bundle(for: type(of: self))).firstLetterUppercased(),
        continueButtonText: localized("next", bundle: Bundle(for: type(of: self))).firstLetterUppercased())
    }
    
    viewController?.updateUI(viewModel: viewModel)
  }
  
  func updateValidEmailAndPassword() {
    viewController?.updateUIValidEmailAndPassword()
  }
  
  func updateInvalidEmailAndPassword() {
    viewController?.updateUIInvalidEmailAndPassword()
  }
}
