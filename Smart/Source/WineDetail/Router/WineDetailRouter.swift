//
//  WineDetailRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import Display
import Sheeeeeeeeet
import UIKit
import VinchyAuthorization
import VinchyCore

// MARK: - WineDetailRouter

final class WineDetailRouter {

  // MARK: Lifecycle

  init(
    input: WineDetailInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: WineDetailInteractorProtocol?

  // MARK: Private

  private let input: WineDetailInput
}

// MARK: WineDetailRouterProtocol

extension WineDetailRouter: WineDetailRouterProtocol {

  func pushToSeeAllStores(wineID: Int64) {
    let controller = StoresAssembly.assemblyModule(input: .init(wineID: wineID))
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(
      controller,
      animated: true)
  }

  func presentStore(affilatedId: Int) {
    let controller = StoreAssembly.assemblyModule(input: .init(mode: .normal(affilatedId: affilatedId)))
//    let navigationController = NavigationController(rootViewController: controller)
//    navigationController.modalPresentationStyle = .overCurrentContext
//    viewController?.navigationController?.present(navigationController, animated: true, completion: nil)
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
    let sheet = menu.toActionSheet { [weak self] aSheet, action in

      guard let self = self else { return }

      guard let action = action.value as? WineDetailMoreActions else {
        return
      }

      aSheet.dismiss {
        switch action {
        case .dislike:
          self.interactor?.didTapDislikeButton()

        case .reportAnError:
          self.interactor?.didTapReportAnError(sourceView: button)
        }
      }
    }

    guard let viewController = viewController else { return }
    sheet.present(in: viewController, from: button)
  }
}
