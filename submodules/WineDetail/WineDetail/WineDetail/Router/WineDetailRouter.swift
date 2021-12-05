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
import VinchyCore
import VinchyUI

// MARK: - WineDetailRouter

final class WineDetailRouter {

  // MARK: Lifecycle

  init(
    input: WineDetailInput,
    viewController: UIViewController,
    coordinator: WineDetailAssembly.Coordinator)
  {
    self.input = input
    self.viewController = viewController
    self.coordinator = coordinator
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: WineDetailInteractorProtocol?
  var coordinator: WineDetailAssembly.Coordinator

  // MARK: Private

  private let input: WineDetailInput
}

// MARK: WineDetailRouterProtocol

extension WineDetailRouter: WineDetailRouterProtocol {

  func presentAuthorizationViewController() {
    coordinator.presentAuthorizationViewController()
  }

  func pushToStoreViewController(affilatedId: Int) {
    coordinator.pushToStoreViewController(affilatedId: affilatedId)
  }

  func pushToStoresViewController(wineID: Int64) {
    coordinator.pushToStoresViewController(wineID: wineID)
  }

  func pushToWineDetailViewController(wineID: Int64) {
    coordinator.pushToWineDetailViewController(wineID: wineID)
  }

  func presentWineDetailViewController(wineID: Int64) {
    coordinator.presentWineDetailViewController(wineID: wineID)
  }

  func pushToReviewsViewController(wineID: Int64) {
    coordinator.pushToReviewsViewController(wineID: wineID)
  }

  func showBottomSheetReviewDetailViewController(reviewInput: ReviewDetailInput) {
    coordinator.showBottomSheetReviewDetailViewController(reviewInput: reviewInput)
  }

  func presentWriteReviewViewController(reviewID: Int?, wineID: Int64, rating: Double, reviewText: String?) {
    coordinator.presentWriteReviewViewController(reviewID: reviewID, wineID: wineID, rating: rating, reviewText: reviewText)
  }

  func presentActivityViewController(items: [Any], sourceView: UIView) {
    coordinator.presentActivityViewController(items: items, sourceView: sourceView)
  }

  func pushToWriteViewController(note: VNote) {
    coordinator.pushToWriteViewController(note: note)
  }

  func presentWriteViewController(note: VNote) {
    coordinator.presentWriteViewController(note: note)
  }

  func pushToWriteViewController(wine: Wine) {
    coordinator.pushToWriteViewController(wine: wine)
  }

  func presentWriteViewController(wine: Wine) {
    coordinator.presentWriteViewController(wine: wine)
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
