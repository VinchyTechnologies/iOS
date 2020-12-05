//
//  NavigationController.swift
//  Display
//
//  Created by Aleksei Smirnov on 17.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Core

public final class NavigationController: UINavigationController {

  let prefersLargeTitles: Bool

  public override init(rootViewController: UIViewController) {
    rootViewController.extendedLayoutIncludesOpaqueBars = true
    self.prefersLargeTitles = true
    super.init(rootViewController: rootViewController)
    extendedLayoutIncludesOpaqueBars = true
  }

  public init(rootViewController: UIViewController, prefersLargeTitles: Bool = true) {
    self.prefersLargeTitles = prefersLargeTitles
    super.init(rootViewController: rootViewController)
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  public override func viewDidLoad() {
    super.viewDidLoad()

    switch UIDevice.type {
    case .iPhoneSE, .iPhone5:
      navigationBar.prefersLargeTitles = false

    default:
      navigationBar.prefersLargeTitles = prefersLargeTitles
    }

//    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)

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
      NSAttributedString.Key.font: Font.semibold(32),
      NSAttributedString.Key.foregroundColor: UIColor.dark
    ]

    UIBarButtonItem.appearance().setTitleTextAttributes([
      NSAttributedString.Key.font: Font.bold(18),
      NSAttributedString.Key.foregroundColor: UIColor.blueGray,
    ], for: .normal)

    UIBarButtonItem.appearance().setTitleTextAttributes([
      NSAttributedString.Key.font: Font.bold(18),
      NSAttributedString.Key.foregroundColor: UIColor.blueGray,
    ], for: .selected)

    UIBarButtonItem.appearance().setTitleTextAttributes([
      NSAttributedString.Key.font: Font.bold(18),
      NSAttributedString.Key.foregroundColor: UIColor.blueGray,
    ], for: .highlighted)
  }

  public override func pushViewController(_ viewController: UIViewController, animated: Bool) {

//    viewController.extendedLayoutIncludesOpaqueBars = true

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
    navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
    UIView.animate(withDuration: 0.25) {
      viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }

    super.pushViewController(viewController, animated: animated)

  }
}
