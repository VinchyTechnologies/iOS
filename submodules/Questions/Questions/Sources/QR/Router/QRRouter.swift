//
//  QRRouter.swift
//  Questions
//
//  Created by Алексей Смирнов on 13.03.2022.
//

import UIKit

// MARK: - QRRouter

final class QRRouter {

  // MARK: Lifecycle

  init(
    input: QRInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: QRInteractorProtocol?

  // MARK: Private

  private let input: QRInput
}

// MARK: QRRouterProtocol

extension QRRouter: QRRouterProtocol {}
