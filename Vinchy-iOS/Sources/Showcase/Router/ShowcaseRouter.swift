//
//  ShowcaseRouter.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/17/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Questions
import UIKit
import VinchyUI

// MARK: - ShowcaseRouter

final class ShowcaseRouter {

  // MARK: Lifecycle

  init(viewController: UIViewController, coordinator: WineDetailRoutable & CollectionShareRoutable & QRRoutable) {
    self.viewController = viewController
    self.coordinator = coordinator
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  var interactor: ShowcaseInteractorProtocol?

  func didTapShareCollection(type: CollectionShareType) {
    coordinator.didTapShareCollection(type: type)
  }

  // MARK: Private

  private let coordinator: WineDetailRoutable & CollectionShareRoutable & QRRoutable

}

// MARK: ShowcaseRouterProtocol

extension ShowcaseRouter: ShowcaseRouterProtocol {

  func presentQRViewController(affilatedId: Int, wineID: Int64) {
    coordinator.presentQRViewController(affilatedId: affilatedId, wineID: wineID)
  }

  func popToRootQuestions() {
    (viewController?.navigationController as? QuestionsNavigationController)?.resetDataSource()
    viewController?.navigationController?.popToRootViewController(animated: true)
  }
}
