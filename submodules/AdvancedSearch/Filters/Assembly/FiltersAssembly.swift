//
//  FiltersAssembly.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import UIKit

public final class FiltersAssembly {

  public static func assemblyModule(input: FiltersInput) -> UIViewController {
    let viewController = FiltersViewController()
    let router = FiltersRouter(input: input, viewController: viewController)
    let presenter = FiltersPresenter(input: input, viewController: viewController)
    let interactor = FiltersInteractor(input: input, router: router, presenter: presenter)
    router.interactor = interactor
    viewController.interactor = interactor
    return viewController
  }
}
