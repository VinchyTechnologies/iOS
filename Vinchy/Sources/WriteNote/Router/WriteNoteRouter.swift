//
//  WriteNoteRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
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
  func dismiss() {
    viewController?.dismiss(animated: true)
  }

  func showAlertYouDidntSaveNote(text: String?, titleText: String?, subtitleText: String?, okText: String?, cancelText: String?, barButtonItem: UIBarButtonItem?) {
    let alert = UIAlertController(title: titleText, message: subtitleText, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: okText, style: .default, handler: { [weak self] _ in
      self?.interactor?.didTapSaveOnAlert(text: text)
    }))
    alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: nil))

    alert.view.tintColor = .accent
    alert.popoverPresentationController?.barButtonItem = barButtonItem
    alert.popoverPresentationController?.permittedArrowDirections = .up

    viewController?.present(alert, animated: true, completion: nil)
  }

  func showAlertToDelete(note: VNote, titleText: String?, subtitleText: String?, okText: String?, cancelText: String?, barButtonItem: UIBarButtonItem?) {
    let alert = UIAlertController(title: titleText, message: subtitleText, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: okText, style: .default, handler: { [weak self] _ in
      self?.interactor?.didTapDeleteNote(note: note)
    }))
    alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: nil))

    alert.view.tintColor = .accent
    alert.popoverPresentationController?.barButtonItem = barButtonItem
    alert.popoverPresentationController?.permittedArrowDirections = .up

    viewController?.present(alert, animated: true, completion: nil)
  }
}
