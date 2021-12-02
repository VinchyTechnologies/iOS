//
//  AreYouInStoreRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit
import VinchyStore
import VinchyUI

// MARK: - AreYouInStoreRouter

final class AreYouInStoreRouter {

  // MARK: Lifecycle

  init(
    input: AreYouInStoreInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: AreYouInStoreInteractorProtocol?

  // MARK: Private

  private let input: AreYouInStoreInput

}

// MARK: AreYouInStoreRouterProtocol

extension AreYouInStoreRouter: AreYouInStoreRouterProtocol {

  func presentStore(affilatedId: Int) {
    let controller = StoreAssembly.assemblyModule(input: .init(mode: .normal(affilatedId: affilatedId)), coordinator: Coordinator.shared)
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .overCurrentContext
    viewController?.present(navigationController, animated: true, completion: nil)
  }
}
