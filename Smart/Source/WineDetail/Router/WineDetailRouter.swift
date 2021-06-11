//
//  WineDetailRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Database
import VinchyCore
import EmailService
import Sheeeeeeeeet
import VinchyAuthorization

final class WineDetailRouter {
  
  weak var viewController: UIViewController?
  weak var interactor: WineDetailInteractorProtocol?
  private let input: WineDetailInput
  private let emailService = EmailService()
  
  init(
    input: WineDetailInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - WineDetailRouterProtocol

extension WineDetailRouter: WineDetailRouterProtocol {

  func presentEmailController(HTMLText: String?, recipients: [String]) {
    
    let emailController = emailService.getEmailController(
      HTMLText: HTMLText,
      recipients: recipients)
    viewController?.present(emailController, animated: true, completion: nil)
  }
  
  func pushToWriteViewController(note: VNote, noteText: String?) {
    let controller = Assembly.buildWriteNoteViewController(for: note)
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
  
  func pushToWriteViewController(wine: Wine) {
    let controller = Assembly.buildWriteNoteViewController(for: wine)
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
  
  func presentActivityViewController(items: [Any], button: UIButton) {
    let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
    if let popoverController = controller.popoverPresentationController {
      popoverController.sourceView = button
      popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
    }
    viewController?.present(controller, animated: true)
  }

  func showMoreActionSheet(menuItems: [MenuItem], appearance: ActionSheetAppearance, button: UIButton) {
    ActionSheet.applyAppearance(appearance, force: true)
    let menu = Menu(items: menuItems)
    let sheet = menu.toActionSheet { [weak self] (aSheet, action) in

      guard let self = self else { return }

      guard let action = action.value as? WineDetailMoreActions else {
        return
      }

      aSheet.dismiss {
        switch action {
        case .dislike:
          self.interactor?.didTapDislikeButton()

        case .reportAnError:
          self.interactor?.didTapReportAnError()
        }
      }
    }

    guard let viewController = viewController else { return }
    sheet.present(in: viewController, from: button)
  }
}
