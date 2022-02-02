//
//  FiltersRouter.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import DisplayMini
import UIKit

// MARK: - FiltersRouter

final class FiltersRouter {

  // MARK: Lifecycle

  init(
    input: FiltersInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: FiltersInteractorProtocol?

  // MARK: Private

  private let input: FiltersInput

}

// MARK: FiltersRouterProtocol

extension FiltersRouter: FiltersRouterProtocol {

  func dismissWithFilters(_ selectedFilters: [(String, String)]) {
    print(selectedFilters)
    (viewController?.navigationController as? AdvancedSearchNavigationController)?.advancedSearchOutputDelegate?.didChoose(selectedFilters)
    viewController?.dismiss(animated: true, completion: nil)
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

extension FiltersRouter: CountriesViewControllerDelegate {
  func didChoose(countryCodes: [String]) {
    interactor?.didChoose(countryCodes: countryCodes)
  }
}
