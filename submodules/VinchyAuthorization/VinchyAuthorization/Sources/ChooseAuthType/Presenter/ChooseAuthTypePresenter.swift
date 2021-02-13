//
//  ChooseAuthTypePresenter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import StringFormatting

final class ChooseAuthTypePresenter {

    private typealias ViewModel = ChooseAuthTypeViewModel

    weak var viewController: ChooseAuthTypeViewControllerProtocol?

    init(viewController: ChooseAuthTypeViewControllerProtocol) {
        self.viewController = viewController
    }
}

// MARK: - ChooseAuthTypePresenterProtocol

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
