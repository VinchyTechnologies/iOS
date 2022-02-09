//
//  NavigationController.swift
//  Display
//
//  Created by Aleksei Smirnov on 17.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import UIKit

// MARK: - VinchyNavigationController

open class VinchyNavigationController: UINavigationController {

  // MARK: Lifecycle

  override public init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    let backImage = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)

    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.shadowColor = .clear
    navBarAppearance.titleTextAttributes = [
      NSAttributedString.Key.font: Font.bold(20),
      NSAttributedString.Key.foregroundColor: UIColor.dark,
    ]
    navBarAppearance.setBackIndicatorImage(
      backImage,
      transitionMaskImage: backImage)

    navigationBar.standardAppearance = navBarAppearance
    navigationBar.scrollEdgeAppearance = navBarAppearance

    switch UIDevice.type {
    case .iPhoneSE, .iPhone5:
      navigationBar.prefersLargeTitles = false

    default:
      navigationBar.prefersLargeTitles = true
    }
  }

  @available(*, unavailable)
  public required init?(coder _: NSCoder) { fatalError() }

  // MARK: Open

  override open func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    getnavigationBarBackground()?.subviews.forEach { view in
      if NSStringFromClass(view.classForCoder).contains("UIBarBackgroundShadowView") {
        view.isHidden = true
      }
    }

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

  // MARK: Public

  override public func viewDidLoad() {
    super.viewDidLoad()

    /// BackgroundColor
    navigationBar.barTintColor = .mainBackground

    /// Icons color
    navigationBar.tintColor = .dark

    /// Remove underline
    navigationBar.shadowImage = UIImage()

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

  override public func viewDidAppear(_ animated: Bool) {
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

  override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
    navigationBar.topItem?.backBarButtonItem = BackBarButtonItem(
      title: "",
      style: .plain,
      target: self,
      action: nil) // not nil only ""
    viewController.navigationItem.leftItemsSupplementBackButton = true
    super.pushViewController(viewController, animated: animated)
  }

  // MARK: Private

  private func getnavigationBarBackground() -> UIView? {
    for subview in navigationBar.subviews {
      if NSStringFromClass(subview.classForCoder).contains("_UIBarBackground") {
        return subview
      }
    }
    return nil
  }

//  private func getLargeTitleView() -> UIView? {
//    for subview in navigationBar.subviews
//      where NSStringFromClass(subview.classForCoder).contains("UINavigationBarLargeTitleView")
//    {
//      return subview
//    }
//
//    return nil
//  }

//  private func getLargeTitleLabel(largeTitleView: UIView) -> UILabel? {
//    for subview in largeTitleView.subviews
//      where subview.isMember(of: UILabel.self)
//    {
//      return subview as? UILabel
//    }
//
//    return nil
//  }
}

// MARK: - BackBarButtonItem

private final class BackBarButtonItem: UIBarButtonItem { // Disale long press on back button for now
  @available(iOS 14.0, *)
  override var menu: UIMenu? {
    set {
      /* Don't set the menu here */
      /* super.menu = menu */
    }
    get {
      super.menu
    }
  }
}
