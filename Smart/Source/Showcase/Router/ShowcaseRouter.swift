//
//  ShowcaseRouter.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/17/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyUI

final class ShowcaseRouter: ShowcaseRouterProtocol {

  // MARK: Lifecycle

  init(viewController: UIViewController, input: ShowcaseInput) {
    self.viewController = viewController
    self.input = input
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  var interactor: ShowcaseInteractorProtocol?

  // MARK: Private

  private let input: ShowcaseInput
}
