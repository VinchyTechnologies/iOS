//
//  Coordinator.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import AdvancedSearch
import FittedSheets
import UIKit
import VinchyAuthorization
import VinchyUI

// MARK: - Coordinator

final class Coordinator: ShowcaseRoutable, WineDetailRoutable, WriteNoteRoutable, ActivityRoutable, AdvancedSearchRoutable, ReviewDetailRoutable, ReviewsRoutable, WriteReviewRoutable, StoresRoutable, StoreRoutable, ResultsSearchRoutable, AuthorizationRoutable {

  static let shared = Coordinator()

  func presentAdvancedSearch(input: AdvancedSearchInput, delegate: AdvancedSearchOutputDelegate?) {
    let controller = AdvancedSearchAssembly.assemblyModule(
      input: input,
      coordinator: Coordinator.shared)
    let navController = AdvancedSearchNavigationController(rootViewController: controller)
    navController.advancedSearchOutputDelegate = delegate
    UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
  }

  func pushToShowcaseViewController(input: ShowcaseInput) {
    let controller = ShowcaseAssembly.assemblyModule(input: input)
    controller.hidesBottomBarWhenPushed = true
    UIApplication.topViewController()?.navigationController?.pushViewController(
      controller,
      animated: true)
  }
}

extension AuthorizationRoutable {
  public func presentAuthorizationViewController() {
    let controller: AuthorizationNavigationController = ChooseAuthTypeAssembly.assemblyModule()
    controller.authOutputDelegate = UIApplication.topViewController() as? AuthorizationOutputDelegate
    let options = SheetOptions(shrinkPresentingViewController: false)
    let sheetController = SheetViewController(
      controller: controller,
      sizes: [.fixed(350)],
      options: options)
    UIApplication.topViewController()?.present(sheetController, animated: true, completion: nil)
  }
}
