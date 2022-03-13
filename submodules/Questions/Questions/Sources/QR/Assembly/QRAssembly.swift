//
//  QRAssembly.swift
//  Questions
//
//  Created by Алексей Смирнов on 13.03.2022.
//

import UIKit

public final class QRAssembly {

  public static func assemblyModule(input: QRInput) -> UIViewController {
    let viewController = QRViewController()
    let router = QRRouter(input: input, viewController: viewController)
    let presenter = QRPresenter(viewController: viewController)
    let interactor = QRInteractor(input: input, router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
