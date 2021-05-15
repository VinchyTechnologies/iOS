//
//  VinchyRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import EmailService
import VinchyCore

final class VinchyRouter {

  let emailService = EmailService()

  weak var viewController: UIViewController?
  weak var interactor: VinchyInteractorProtocol?

  init(viewController: UIViewController) {
    self.viewController = viewController
  }
}

extension VinchyRouter: VinchyRouterProtocol {

  func pushToAdvancedFilterViewController() {
    viewController?.navigationController?.pushViewController(
      Assembly.buildFiltersModule(), animated: true)
  }

  func pushToDetailCollection(searchText: String) {
    let input = ShowcaseInput(title: nil, mode: .advancedSearch(params: [("title", searchText)]))
    pushToShowcaseViewController(input: input)
  }

  func presentEmailController(HTMLText: String?, recipients: [String]) {
    let emailController = emailService.getEmailController(
      HTMLText: HTMLText,
      recipients: recipients)
    viewController?.present(emailController, animated: true, completion: nil)
  }
}
