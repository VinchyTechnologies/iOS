//
//  NotesAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class NotesAssembly {
  static func assemblyModule() -> UIViewController {
    let viewController = NotesViewController()
    let router = NotesRouter(viewController: viewController)
    let presenter = NotesPresenter(viewController: viewController)
    let interactor = NotesInteractor(router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
