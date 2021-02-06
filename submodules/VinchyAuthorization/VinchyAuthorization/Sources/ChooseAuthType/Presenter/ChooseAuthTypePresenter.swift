//
//  ChooseAuthTypePresenter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import Foundation

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
    let viewModel = ChooseAuthTypeViewModel(titleText: "Welcome", subtitleText: "Here you need to register", loginButtonText: "Log in", registerButtonText: "Register")
    viewController?.updateUI(viewModel: viewModel)
  }
}
