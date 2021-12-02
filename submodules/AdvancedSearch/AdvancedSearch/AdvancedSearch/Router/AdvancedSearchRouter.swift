//
//  AdvancedSearchRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import UIKit
import VinchyUI

// MARK: - AdvancedSearchRouter

final class AdvancedSearchRouter {

  // MARK: Lifecycle

  init(
    input: AdvancedSearchInput,
    viewController: UIViewController,
    coordinator: AdvancedSearchAssembly.Coordinator)
  {
    self.input = input
    self.viewController = viewController
    self.coordinator = coordinator
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: AdvancedSearchInteractorProtocol?
  var coordinator: AdvancedSearchAssembly.Coordinator

  // MARK: Private

  private let input: AdvancedSearchInput
}

// MARK: AdvancedSearchRouterProtocol

extension AdvancedSearchRouter: AdvancedSearchRouterProtocol {

  func pushToShowcaseViewController(input: ShowcaseInput) {
    coordinator.pushToShowcaseViewController(input: input)
  }

  func dismiss(selectedFilters: [(String, String)]) {
    viewController?.dismiss(animated: true, completion: {
      (self.viewController?.navigationController as? AdvancedSearchNavigationController)?.advancedSearchOutputDelegate?.didChoose(selectedFilters)
    })
  }

  func presentAllCountries(preSelectedCountryCodes: [String]) {
    let controller = CountriesViewController(preSelectedCountryCodes: preSelectedCountryCodes, delegate: self)
    let navController = VinchyNavigationController(rootViewController: controller)
    viewController?.present(
      navController,
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
