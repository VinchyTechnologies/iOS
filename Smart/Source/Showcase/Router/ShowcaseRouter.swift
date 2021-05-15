//
//  ShowcaseRouter.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/17/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class ShowcaseRouter: ShowcaseRouterProtocol {
  
  weak var viewController: UIViewController?
   var interactor: ShowcaseInteractorProtocol?
  private let input: ShowcaseInput
  
  init(viewController: UIViewController, input: ShowcaseInput) {
    self.viewController = viewController
    self.input = input
  }
}
