//
//  ShowcaseAssembly.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class ShowcaseAssembly {

  static func assemblyModule(input: ShowcaseInput) -> ShowcaseViewController {
    
    let viewController = ShowcaseViewController(mode: input.mode)
    let router = ShowcaseRouter(viewController: viewController, input: input)
    let presenter = ShowcasePresenter(viewController: viewController, input: input)
    let interactor = ShowcaseInteractor(router: router, presenter: presenter, mode: input.mode)

    viewController.interactor = interactor

    return viewController
  }
}
