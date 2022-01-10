//
//  SimpleContinuosCarouselCollectionCellRouter.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import UIKit
import VinchyCore
import VinchyUI

// MARK: - SimpleContinuosCarouselCollectionCellRouter

final class SimpleContinuosCarouselCollectionCellRouter {

  // MARK: Lifecycle

  init(
    input: SimpleContinuosCarouselCollectionCellInput,
    viewController: UIViewController?)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: SimpleContinuosCarouselCollectionCellInteractorProtocol?

  // MARK: Private

  private let input: SimpleContinuosCarouselCollectionCellInput
}

// MARK: SimpleContinuosCarouselCollectionCellRouterProtocol

extension SimpleContinuosCarouselCollectionCellRouter: SimpleContinuosCarouselCollectionCellRouterProtocol {
  func pushToWriteViewController(note: VNote) {

  }

  func pushToWriteViewController(wine: Wine) {

  }

  func presentActivityViewController(items: [Any]) {
    let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
    if let popoverController = controller.popoverPresentationController {
      popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
    }
    viewController?.present(controller, animated: true)
  }
}
