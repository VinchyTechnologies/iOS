//
//  EditProfileRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - EditProfileRouter

final class EditProfileRouter {

  // MARK: Lifecycle

  init(
    input: EditProfileInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: EditProfileInteractorProtocol?

  // MARK: Private

  private let input: EditProfileInput
}

// MARK: EditProfileRouterProtocol

extension EditProfileRouter: EditProfileRouterProtocol {
  func dismiss() {
    input.onDismiss?()
    viewController?.dismiss(animated: true)
  }
}
