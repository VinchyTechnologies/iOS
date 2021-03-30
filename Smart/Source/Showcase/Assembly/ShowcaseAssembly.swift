//
//  ShowcaseAssembly.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class ShowcaseAssembly {

  static func assemblyModule(title: String?, mode: ShowcaseMode) -> ShowcaseViewController {
    
    let viewController = ShowcaseViewController(navTitle: title, mode: mode)
    let router = ShowcaseRouter(viewController: viewController)
    let presenter = ShowcasePresenter(viewController: viewController)
    let interactor = ShowcaseInteractor(presenter: presenter, router: router)

    viewController.interactor = interactor

    return viewController
  }
}
