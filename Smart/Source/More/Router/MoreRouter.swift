//
//  MoreRouter.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import Core
import Display
import UIKit

// MARK: - MoreRouter

final class MoreRouter {

  // MARK: Lifecycle

  init(viewController: MoreViewController) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: MoreInteractorProtocol?

  // MARK: Private

  private let emailService = EmailService()
}

// MARK: MoreRouterProtocol

extension MoreRouter: MoreRouterProtocol {

  func presentAlertAreYouSureLogout(titleText: String?, subtitleText: String?, leadingButtonText: String?, trailingButtonText: String?) {
    let alert = UIAlertController(title: titleText, message: subtitleText, preferredStyle: .alert)
    alert.view.tintColor = .accent

    alert.addAction(UIAlertAction(title: trailingButtonText, style: .default, handler: { [weak self] _ in
      self?.interactor?.didTapLogoutOnAlert()
    }))

    alert.addAction(UIAlertAction(title: leadingButtonText, style: .cancel, handler: nil))

    viewController?.present(alert, animated: true, completion: nil)
  }

  func presentShowEditProfileViewController() {
    let rootViewController = EditProfileAssembly.assemblyModule(input: EditProfileInput(onDismiss: { [weak self] in
      self?.interactor?.viewDidLoad()
    }))
    let controller = VinchyNavigationController(rootViewController: rootViewController)
    viewController?.present(controller, animated: true)
  }

  func pushToCurrencyViewController() {
    let controller = CurrencyAssembly.assemblyModule()
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }

  func presentEmailController(HTMLText: String?, recipients: [String]) {
    let emailController = emailService.getEmailController(
      HTMLText: HTMLText,
      recipients: recipients)
    viewController?.present(emailController, animated: true, completion: nil)
  }

  func pushToAboutController() {
    let controller = AboutViewController()
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }

  func pushToDocController() {
    let controller = DocumentsAssembly.assemblyModule() //DocController()
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }

  func present(_ viewController: UIViewController, completion: (() -> Void)?) {
    self.viewController?.navigationController?.present(viewController, animated: true, completion: completion)
  }
}
