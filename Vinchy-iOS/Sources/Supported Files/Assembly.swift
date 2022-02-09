//
//  Assembly.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 01.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AdvancedSearch
import Database
import DisplayMini
import StringFormatting
import UIKit
import VinchyCore
import WineDetail

@available(*, deprecated, message: "Use routable")
final class Assembly {
  static func buildDetailModule(wineID: Int64) -> UIViewController {
    let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID, isAppClip: false), coordinator: Coordinator.shared, adGenerator: AdFabric.shared)
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

//  static func buildReviewDetailViewController(
//    rate: Double?,
//    author: String?,
//    date: String?,
//    reviewText: String?)
//    -> UIViewController
//  {
//    let controller = ReviewDetailAssembly.assemblyModule(
//      input: .init(rate: rate, author: author, date: date, reviewText: reviewText))
//    controller.hidesBottomBarWhenPushed = true
//    return controller
//  }

  static func buildMapViewController() -> UIViewController {
    let controller = MapAssembly.assemblyModule()
    controller.hidesBottomBarWhenPushed = true
    return controller
  }
}
