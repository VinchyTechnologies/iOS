//
//  ShowcaseRouter.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/17/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class ShowcaseRouter: ShowcaseRouterProtocol {

  // MARK: Lifecycle

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  var interactor: ShowcaseInteractorProtocol?

}
