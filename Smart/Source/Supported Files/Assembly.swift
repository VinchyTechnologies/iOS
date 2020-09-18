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

final class Assembly {

    static func buildDetailModule(wineID: Int64) -> UIViewController {
        let controller = WineDetailViewController(wineID: wineID)
        controller.hidesBottomBarWhenPushed = true
        controller.extendedLayoutIncludesOpaqueBars = true
        return controller
    }

    static func buildFiltersModule() -> UIViewController {
        let controller = AdvancedSearchViewController()
        controller.hidesBottomBarWhenPushed = true
        return controller
    }

    static func buildMainModule() -> NavigationController {
        let controller = NewVinchyViewController()
        controller.title = localized("explore").firstLetterUppercased()
        controller.extendedLayoutIncludesOpaqueBars = true
        let navController = NavigationController(rootViewController: controller)
        return navController
    }

    static func buildShowcaseModule(navTitle: String?, mode: ShowcaseMode) -> UIViewController {
        let controller = ShowcaseViewController(navTitle: navTitle, mode: mode)
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

    static func buildChooseCountiesModule(preSelectedCountryCodes: [String], delegate: CountriesViewControllerDelegate) -> NavigationController {
        let controller = CountriesViewController(preSelectedCountryCodes: preSelectedCountryCodes, delegate: delegate)
        let navController = NavigationController(rootViewController: controller)
        navController.modalPresentationCapturesStatusBarAppearance = true
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
