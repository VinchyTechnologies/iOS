//
//  ShowcaseRouter.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/17/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

final class ShowcaseRouter: ShowcaseRouterProtocol {

  // MARK: Lifecycle

  init(viewController: UIViewController, coordinator: WineDetailRoutable & CollectionShareRoutable) {
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

  private let coordinator: WineDetailRoutable & CollectionShareRoutable

}
