//
//  Assembly.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 01.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AdvancedSearch
import CommonUI
import Database
import Display
import StringFormatting
import VinchyCore

final class Assembly {
  @available(*, deprecated, message: "Use routable")
  static func buildDetailModule(wineID: Int64) -> UIViewController {
    let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID))
    controller.hidesBottomBarWhenPushed = true
    return controller
  }

  static func buildFiltersModule() -> UIViewController {
    let controller = AdvancedSearchAssembly.assemblyModule(
      input: .init(mode: .normal),
      coordinator: Coordinator.shared)
    controller.hidesBottomBarWhenPushed = true
    return controller
  }

  static func buildMainModule() -> VinchyNavigationController {
    let controller = VinchyAssembly.assemblyModule()
    let navController = VinchyNavigationController(rootViewController: controller)
    return navController
  }

  static func buildLoveModule() -> VinchyNavigationController {
    let controller = LoveViewController()
    let navController = VinchyNavigationController(rootViewController: controller)
    return navController
  }

  static func buildProfileModule() -> VinchyNavigationController {
    let controller = MoreAssembly.assemblyModule()
    let navController = VinchyNavigationController(rootViewController: controller)
    return navController
  }

//  static func buildChooseCountiesModule(preSelectedCountryCodes: [String], delegate: CountriesViewControllerDelegate) -> VinchyNavigationController {
//    let controller = CountriesViewController(preSelectedCountryCodes: preSelectedCountryCodes, delegate: delegate)
//    let navController = VinchyNavigationController(rootViewController: controller)
//    return navController
//  }

  static func buildWriteNoteViewController(for wine: Wine) -> UIViewController {
    let controller = WriteNoteAssembly.assemblyModule(input: .init(wine: .firstTime(wine: wine)))
    controller.hidesBottomBarWhenPushed = true
    return controller
  }

  static func buildWriteNoteViewController(for note: VNote) -> UIViewController {
    let controller = WriteNoteAssembly.assemblyModule(input: .init(wine: .database(note: note)))
    controller.hidesBottomBarWhenPushed = true
    return controller
  }

  static func buildReviewDetailViewController(
    rate: Double?,
    author: String?,
    date: String?,
    reviewText: String?)
    -> UIViewController
  {
    let controller = ReviewDetailAssembly.assemblyModule(
      input: .init(rate: rate, author: author, date: date, reviewText: reviewText))
    controller.hidesBottomBarWhenPushed = true
    return controller
  }

  static func buildMapViewController() -> UIViewController {
    let controller = MapAssembly.assemblyModule()
    controller.hidesBottomBarWhenPushed = true
    return controller
  }
}
