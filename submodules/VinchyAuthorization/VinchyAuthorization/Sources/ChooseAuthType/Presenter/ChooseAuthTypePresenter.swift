//
//  ChooseAuthTypePresenter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import StringFormatting

// MARK: - ChooseAuthTypePresenter

final class ChooseAuthTypePresenter {

  // MARK: Lifecycle

  init(viewController: ChooseAuthTypeViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: ChooseAuthTypeViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = ChooseAuthTypeViewModel
}

// MARK: ChooseAuthTypePresenterProtocol

extension ChooseAuthTypePresenter: ChooseAuthTypePresenterProtocol {
  func update() {
    let viewModel = ChooseAuthTypeViewModel(
      titleText: localized("hello", bundle: Bundle(for: type(of: self))).firstLetterUppercased(),
      subtitleText: "", // TODO: - Remove from VC
      loginButtonText: localized("sign_in", bundle: Bundle(for: type(of: self))).firstLetterUppercased(),
      registerButtonText: localized("register", bundle: Bundle(for: type(of: self))).firstLetterUppercased())
    viewController?.updateUI(viewModel: viewModel)
  }
}
