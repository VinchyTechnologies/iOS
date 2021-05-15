//
//  Assembly.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 01.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import SwiftUI
import StringFormatting
import Display
import VinchyCore
import CommonUI
import Database

final class Assembly {

  @available(*, deprecated, message: "Use routable")
  static func buildDetailModule(wineID: Int64) -> UIViewController {
    let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID))
    controller.hidesBottomBarWhenPushed = true
    return controller
  }

  static func buildFiltersModule() -> UIViewController {
    let controller = AdvancedSearchAssembly.assemblyModule()
    controller.hidesBottomBarWhenPushed = true
    return controller
  }

  static func buildMainModule() -> NavigationController {
    let controller = VinchyAssembly.assemblyModule()
    controller.title = localized("explore").firstLetterUppercased()
    let navController = NavigationController(rootViewController: controller)
    return navController
  }

  static func buildLoveModule() -> NavigationController {
    let controller = LoveViewController()
    let navController = NavigationController(rootViewController: controller)
    return navController
  }

  static func buildProfileModule() -> NavigationController {
    let controller = MoreAssembly.assemblyModule()
    let navController = NavigationController(rootViewController: controller)
    return navController
  }

  static func buildChooseCountiesModule(preSelectedCountryCodes: [String], delegate: CountriesViewControllerDelegate) -> NavigationController {
    let controller = CountriesViewController(preSelectedCountryCodes: preSelectedCountryCodes, delegate: delegate)
    let navController = NavigationController(rootViewController: controller)
    return navController
  }

  static func buildWriteNoteViewController(for wine: Wine) -> UIViewController {
    let controller = WriteNoteAssembly.assemblyModule(input: .init(wine: .firstTime(wine: wine)))
    controller.hidesBottomBarWhenPushed = true
    return controller
  }

  static func buildWriteNoteViewController(for note: Note) -> UIViewController {
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
