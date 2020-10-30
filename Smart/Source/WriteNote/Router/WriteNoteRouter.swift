//
//  WriteNoteRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class WriteNoteRouter {
  
  weak var viewController: UIViewController?
  weak var interactor: WriteNoteInteractorProtocol?
  private let input: WriteNoteInput
  
  init(
    input: WriteNoteInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - WriteNoteRouterProtocol

extension WriteNoteRouter: WriteNoteRouterProtocol {
  func pop() {
    viewController?.navigationController?.popViewController(animated: true)
  }
}
