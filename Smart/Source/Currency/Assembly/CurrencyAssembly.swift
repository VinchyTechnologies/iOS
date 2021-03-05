//
//  CurrencyAssembly.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/1/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class CurrencyAssembly {

  static func assemblyModule() -> UIViewController {

    let viewController = CurrencyViewController()
    let router = CurrencyRouter(viewController: viewController)
    let presenter = CurrencyPresenter(viewController: viewController)
    let interactor = CurrencyInteractor(presenter: presenter, router: router)

    viewController.interactor = interactor

    return viewController
  }
}
