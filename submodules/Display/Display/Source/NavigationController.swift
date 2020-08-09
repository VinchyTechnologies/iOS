//
//  NavigationController.swift
//  Display
//
//  Created by Aleksei Smirnov on 17.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

public final class NavigationController: UINavigationController {

    // MARK: - Initializers

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        rootViewController.extendedLayoutIncludesOpaqueBars = true
        extendedLayoutIncludesOpaqueBars = true
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        /// BackgroundColor
        navigationBar.barTintColor = .mainBackground
        navigationBar.isTranslucent = false

        /// Remove underline
        navigationBar.shadowImage = UIImage()

        /// Icons color
        navigationBar.tintColor = .dark

        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Font.semibold(20),
            NSAttributedString.Key.foregroundColor: UIColor.dark
        ]

        navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: Font.bold(30),
            NSAttributedString.Key.foregroundColor: UIColor.dark
        ]

        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font : Font.bold(18),
            NSAttributedString.Key.foregroundColor : UIColor.blueGray,
        ], for: .normal)

        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font : Font.bold(18),
            NSAttributedString.Key.foregroundColor : UIColor.blueGray,
        ], for: .selected)

        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font : Font.bold(18),
            NSAttributedString.Key.foregroundColor : UIColor.blueGray,
        ], for: .highlighted)

    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        viewController.extendedLayoutIncludesOpaqueBars = true

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
        navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        super.pushViewController(viewController, animated: animated)
    }

}

