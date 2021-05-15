//
//  AdvancedSearchRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import CommonUI

final class AdvancedSearchRouter {
  
  weak var viewController: UIViewController?
  weak var interactor: AdvancedSearchInteractorProtocol?
  private let input: AdvancedSearchInput
  
  init(
    input: AdvancedSearchInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - AdvancedSearchRouterProtocol

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

extension AdvancedSearchRouter: CountriesViewControllerDelegate {
  func didChoose(countryCodes: [String]) {
    interactor?.didChooseCountryCodes(countryCodes)
  }
}
