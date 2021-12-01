//
//  AdvancedSearchAssembly.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

// MARK: - AdvancedSearchAssembly

public final class AdvancedSearchAssembly {

  public typealias Coordinator = ShowcaseRoutable

  public static func assemblyModule(input: AdvancedSearchInput, coordinator: Coordinator) -> UIViewController {
    let viewController = AdvancedSearchViewController()
    let router = AdvancedSearchRouter(input: input, viewController: viewController, coordinator: coordinator)
    let presenter = AdvancedSearchPresenter(input: input, viewController: viewController)
    let interactor = AdvancedSearchInteractor(input: input, router: router, presenter: presenter)
    router.interactor = interactor
    viewController.interactor = interactor
    return viewController
  }
}
