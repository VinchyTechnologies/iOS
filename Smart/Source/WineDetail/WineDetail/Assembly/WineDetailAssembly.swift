//
//  WineDetailAssembly.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class WineDetailAssembly {

    static func assemblyModule(input: WineDetailInput) -> WineDetailViewController {

        let viewController = WineDetailViewController()

        let router = WineDetailRouter(input: input, viewController: viewController)
        let presenter = WineDetailPresenter(viewController: viewController)
        let interactor = WineDetailInteractor(input: input, router: router, presenter: presenter)

        router.interactor = interactor
        viewController.interactor = interactor

        return viewController
    }

}
