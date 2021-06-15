//
//  AdvancedSearchRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import UIKit

// MARK: - AdvancedSearchRouter

final class AdvancedSearchRouter {

  // MARK: Lifecycle

  init(
    input: AdvancedSearchInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: AdvancedSearchInteractorProtocol?

  // MARK: Private

  private let input: AdvancedSearchInput
}

// MARK: AdvancedSearchRouterProtocol

extension AdvancedSearchRouter: AdvancedSearchRouterProtocol {
  func presentAllCountries(preSelectedCountryCodes: [String]) {
    viewController?.present(
      Assembly.buildChooseCountiesModule(
        preSelectedCountryCodes: preSelectedCountryCodes,
        delegate: self),
      animated: true,
      completion: nil)
  }
}

// MARK: CountriesViewControllerDelegate

extension AdvancedSearchRouter: CountriesViewControllerDelegate {
  func didChoose(countryCodes: [String]) {
    interactor?.didChooseCountryCodes(countryCodes)
  }
}
