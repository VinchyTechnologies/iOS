//
//  StoresRouter.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit
import VinchyStore
import VinchyUI

// MARK: - StoresRouter

final class StoresRouter {

  // MARK: Lifecycle

  init(
    input: StoresInput,
    adFabricProtocol: AdFabricProtocol?,
    repository: StoreRepositoryAdapterProtocol?,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
    self.adFabricProtocol = adFabricProtocol
    self.repository = repository
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: StoresInteractorProtocol?

  // MARK: Private

  private let adFabricProtocol: AdFabricProtocol?
  private let repository: StoreRepositoryAdapterProtocol?

  private let input: StoresInput
}

// MARK: StoresRouterProtocol

extension StoresRouter: StoresRouterProtocol {
  func presentStore(affilatedId: Int) {
    let controller = StoreAssembly.assemblyModule(
      input: .init(mode: .normal(affilatedId: affilatedId), isAppClip: false),
      coordinator: Coordinator.shared,
      adFabricProtocol: adFabricProtocol,
      repository: repository)
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
}
