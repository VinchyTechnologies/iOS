//
//  WriteNoteAssembly.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

enum WriteNoteAssembly {
  static func assemblyModule(input: WriteNoteInput) -> WriteNoteViewController {
    let viewController = WriteNoteViewController()

    let router = WriteNoteRouter(input: input, viewController: viewController)
    let presenter = WriteNotePresenter(viewController: viewController)
    let interactor = WriteNoteInteractor(input: input, router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor

    return viewController
  }
}
