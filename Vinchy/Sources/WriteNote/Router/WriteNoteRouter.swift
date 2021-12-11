//
//  WriteNoteRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - WriteNoteRouter

final class WriteNoteRouter {

  // MARK: Lifecycle

  init(
    input: WriteNoteInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: WriteNoteInteractorProtocol?

  // MARK: Private

  private let input: WriteNoteInput
}

// MARK: WriteNoteRouterProtocol

extension WriteNoteRouter: WriteNoteRouterProtocol {
  func pop() {
    viewController?.navigationController?.popViewController(animated: true)
  }
}
