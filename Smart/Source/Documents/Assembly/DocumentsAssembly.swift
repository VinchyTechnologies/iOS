//
//  DocumentsAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class DocumentsAssembly {
  static func assemblyModule() -> UIViewController {
    let viewController = DocumentsViewController()
    let router = DocumentsRouter(viewController: viewController)
    let presenter = DocumentsPresenter(viewController: viewController)
    let interactor = DocumentsInteractor(router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
