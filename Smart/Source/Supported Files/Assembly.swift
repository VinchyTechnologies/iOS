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

final class Assembly {

    static func buildDetailModule(wineID: Int64) -> UIViewController {
        let controller = DetailProductController(wineID: wineID)
        controller.hidesBottomBarWhenPushed = true
        controller.extendedLayoutIncludesOpaqueBars = true
        return controller
    }

    static func buildFiltersModule() -> UIViewController {
        let controller = FiltersViewController()
        controller.hidesBottomBarWhenPushed = true
        return controller
    }

    static func buildMainModule() -> NavigationController {
        let controller = MainViewController()
        controller.title = localized("explore").firstLetterUppercased()
        controller.extendedLayoutIncludesOpaqueBars = true
        let navController = NavigationController(rootViewController: controller)
        return navController
    }

    static func buildShowcaseModule(navTitle: String?, wines: [Wine], fromFilter: Bool) -> UIViewController {
        let controller = ShowcaseViewController(navTitle: navTitle, wines: wines, fromFilter: fromFilter)
        controller.extendedLayoutIncludesOpaqueBars = true
        controller.hidesBottomBarWhenPushed = true
        return controller
    }

    static func buildLoveModule() -> NavigationController {
        let controller = LoveViewController()
        let navController = NavigationController(rootViewController: controller)
        return navController
    }

    static func buildProfileModule() -> NavigationController {
//        let view = ProfileView()
//        let controller = UIHostingController(rootView: view)
//        controller.title = localized("profile").firstLetterUppercased()

        let controller = MoreViewController()
        let navController = NavigationController(rootViewController: controller)
        return navController
    }

    static func buildSubscriptionModule() -> NavigationController {
        let controller = SubscriptionViewController()
        let navController = NavigationController(rootViewController: controller)
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationItem.title = localized("subscriptions")
        return navController
    }

    static func startAuthFlow(completion: (() -> Void)?) {
        let controller = EmailViewController()
        controller.authCompletion = completion
        let navController = NavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
    }
}
