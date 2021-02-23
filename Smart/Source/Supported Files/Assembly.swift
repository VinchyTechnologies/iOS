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

  static func buildShowcaseModule(navTitle: String?, mode: ShowcaseMode) -> UIViewController {
    let controller = ShowcaseViewController(navTitle: navTitle, mode: mode)
    controller.hidesBottomBarWhenPushed = true
    return controller
  }

  static func buildLoveModule() -> NavigationController {
    let controller = LoveViewController()
    let navController = NavigationController(rootViewController: controller, prefersLargeTitles: false)
    return navController
  }

  static func buildProfileModule() -> NavigationController {
    let controller = MoreAssembly.assemblyModule()
    let navController = NavigationController(rootViewController: controller)
    return navController
  }

  static func buildChooseCountiesModule(preSelectedCountryCodes: [String], delegate: CountriesViewControllerDelegate) -> NavigationController {
    let controller = CountriesViewController(preSelectedCountryCodes: preSelectedCountryCodes, delegate: delegate)
    let navController = NavigationController(rootViewController: controller, prefersLargeTitles: false)
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
  
  static func buildReviewsViewController(wineID: Int64) -> UIViewController {
    let controller = ReviewsAssembly.assemblyModule()
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
  
  static func buildWriteReviewViewController(
    reviewID: Int?,
    wineID: Int64,
    rating: Double?,
    reviewText: String?)
    -> UIViewController
  {
    let controller = WriteReviewAssembly.assemblyModule(
      input: .init(reviewID: reviewID, wineID: wineID, rating: rating, comment: reviewText))
    let navController = NavigationController(rootViewController: controller)
    return navController
  }
}
