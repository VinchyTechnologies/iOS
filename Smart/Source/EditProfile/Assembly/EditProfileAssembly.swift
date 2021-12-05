//
//  EditProfileAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class EditProfileAssembly {
  static func assemblyModule(input: EditProfileInput) -> UIViewController {
    let viewController = EditProfileViewController()
    let router = EditProfileRouter(input: input, viewController: viewController)
    let presenter = EditProfilePresenter(viewController: viewController)
    let interactor = EditProfileInteractor(router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor

    return viewController
  }
}
