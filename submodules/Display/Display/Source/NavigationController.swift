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

  // MARK: - Private Properties

  private let prefersLargeTitles: Bool

  // MARK: - Initializers

  public init(rootViewController: UIViewController, prefersLargeTitles: Bool = true) {
    self.prefersLargeTitles = prefersLargeTitles
    super.init(rootViewController: rootViewController)
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  // MARK: - Lifecycle

  public override func viewDidLoad() {
    super.viewDidLoad()

    switch UIDevice.type {
    case .iPhoneSE, .iPhone5:
      navigationBar.prefersLargeTitles = false

    default:
      navigationBar.prefersLargeTitles = prefersLargeTitles
    }

    /// BackgroundColor
    navigationBar.barTintColor = .mainBackground

    /// Icons color
    navigationBar.tintColor = .dark

    /// Remove underline
    navigationBar.shadowImage = UIImage()

    navigationBar.titleTextAttributes = [
      NSAttributedString.Key.font: Font.bold(20),
      NSAttributedString.Key.foregroundColor: UIColor.dark
    ]

    UIBarButtonItem.appearance().setTitleTextAttributes([
      NSAttributedString.Key.font: Font.bold(18),
      NSAttributedString.Key.foregroundColor: UIColor.dark,
    ], for: .normal)

    UIBarButtonItem.appearance().setTitleTextAttributes([
      NSAttributedString.Key.font: Font.bold(18),
      NSAttributedString.Key.foregroundColor: UIColor.dark,
    ], for: .selected)

    UIBarButtonItem.appearance().setTitleTextAttributes([
      NSAttributedString.Key.font: Font.bold(18),
      NSAttributedString.Key.foregroundColor: UIColor.dark,
    ], for: .highlighted)
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    if let lagerTitleView = getLargeTitleView(),
//       let lagerTitleLabel = getLargeTitleLabel(largeTitleView: lagerTitleView) {
//      lagerTitleLabel.numberOfLines = 2
//    }

    getnavigationBarBackground()?.subviews.forEach { view in
      if view.isMember(of: UIVisualEffectView.self) {
        
        if let visualView = view as? UIVisualEffectView {
          for subview in visualView.subviews {
            subview.isHidden = true
          }
          visualView.contentView.backgroundColor = .mainBackground
          visualView.backgroundColor = .mainBackground
        }
      }
    }
  }

  private func getnavigationBarBackground() -> UIView? {
    for subview in self.navigationBar.subviews {
      if NSStringFromClass(subview.classForCoder).contains("_UIBarBackground") {
        return subview
      }
    }
    return nil
  }

  private func getLargeTitleView() -> UIView? {
    for subview in self.navigationBar.subviews
      where NSStringFromClass(subview.classForCoder).contains("UINavigationBarLargeTitleView") {
      return subview
    }

    return nil
  }

  private func getLargeTitleLabel(largeTitleView: UIView) -> UILabel? {
    for subview in largeTitleView.subviews
      where subview.isMember(of: UILabel.self) {
      return subview as? UILabel
    }

    return nil
  }

  public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
    navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
    viewController.navigationItem.leftItemsSupplementBackButton = true

    super.pushViewController(viewController, animated: animated)
  }
}
