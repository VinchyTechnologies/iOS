//
//  AddressSearchRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - AddressSearchRouter

final class AddressSearchRouter {

  // MARK: Lifecycle

  init(
    input: AddressSearchInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: AddressSearchInteractorProtocol?

  // MARK: Private

  private let input: AddressSearchInput

}

// MARK: AddressSearchRouterProtocol

extension AddressSearchRouter: AddressSearchRouterProtocol {
  func dismiss() {
    viewController?.navigationController?.dismiss(animated: true, completion: nil)
    (viewController?.navigationController?.viewControllers.first as? AddressSearchViewController)?.delegate?.didChooseAddress()
  }
}
