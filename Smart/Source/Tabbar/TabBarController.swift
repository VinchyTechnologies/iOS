//
//  TabBarController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 16.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Combine
import Display
import StringFormatting
import UIKit

// MARK: - TabBarDeeplinkable

protocol TabBarDeeplinkable {
  func openWineDetail(wineID: Int64) -> AnyPublisher<TabBarDeeplinkable, Never>
  func selectSecondTab() -> AnyPublisher<TabBarDeeplinkable, Never>
  func makeSearchBarFirstResponder() -> AnyPublisher<TabBarDeeplinkable, Never>
}

// MARK: - ScrollableToTop

protocol ScrollableToTop {
  var scrollableToTopScrollView: UIScrollView { get }
}

// MARK: - TabBarController

final class TabBarController: UITabBarController, UITabBarControllerDelegate {

  // MARK: Public

  override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .portrait
    } else {
      return .all
    }
  }

  // MARK: Internal

  override var shouldAutorotate: Bool {
    !(UIDevice.current.userInterfaceIdiom == .phone)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let colorNormal = UIColor.blueGray
    let colorSelected = UIColor.dark
    let titleFontAll: UIFont = Font.semibold(11)

    let attributesNormal = [
      NSAttributedString.Key.foregroundColor: colorNormal,
      NSAttributedString.Key.font: titleFontAll,
    ]

    let attributesSelected = [
      NSAttributedString.Key.foregroundColor: colorSelected,
      NSAttributedString.Key.font: titleFontAll,
    ]

    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .mainBackground
    let tabBarItemAppearance = UITabBarItemAppearance()
    tabBarItemAppearance.selected.titleTextAttributes = attributesSelected
    tabBarItemAppearance.normal.titleTextAttributes = attributesNormal
    appearance.stackedLayoutAppearance = tabBarItemAppearance
    appearance.compactInlineLayoutAppearance = tabBarItemAppearance
    appearance.inlineLayoutAppearance = tabBarItemAppearance

    tabBar.standardAppearance = appearance
    if #available(iOS 15.0, *) {
      tabBar.scrollEdgeAppearance = appearance
    }
    tabBar.isTranslucent = false

    delegate = self

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)

    let main = Assembly.buildMainModule()
    main.tabBarItem = UITabBarItem(
      title: localized("explore").firstLetterUppercased(),
      image: UIImage(systemName: "square.grid.2x2", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal),
      selectedImage: UIImage(systemName: "square.grid.2x2", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal))

    let love = Assembly.buildLoveModule()
    love.tabBarItem = UITabBarItem(
      title: localized("favourites").firstLetterUppercased(),
      image: UIImage(systemName: "heart", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal),
      selectedImage: UIImage(systemName: "heart", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal))

    let notes = NavigationController(rootViewController: NotesAssembly.assemblyModule())
    notes.tabBarItem = UITabBarItem(
      title: localized("notes").firstLetterUppercased(),
      image: UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal),
      selectedImage: UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal))

    let profile = Assembly.buildProfileModule()
    profile.tabBarItem = UITabBarItem(
      title: localized("profile").firstLetterUppercased(),
      image: UIImage(systemName: "person.circle", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal),
      selectedImage: UIImage(systemName: "person.circle", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal))

    /*
     let chat = NavigationController(rootViewController: BasicExampleViewController())
     chat.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bubble.left"), selectedImage: nil)

     let cart = NavigationController(rootViewController: CartViewController())
     cart.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "cart"), selectedImage: nil)

     let somelier = Assembly.buildSomelierModule()
     somelier.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "rectangle.stack"), selectedImage: nil)
     */

    let map = Assembly.buildMapViewController()
    map.tabBarItem = UITabBarItem(
      title: localized("map").firstLetterUppercased(),
      image: UIImage(systemName: "map", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal),
      selectedImage: UIImage(systemName: "map", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal))

//    [main, love, notes, profile].forEach { controller in
//      controller.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -3)
//      controller.tabBarItem.imageInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
//    }

    viewControllers = [main, love, map, notes, profile]
  }

  override func viewWillLayoutSubviews() {
    if let items = tabBar.items {
      items.forEach { item in
        let viewTabBar = item.value(forKey: "view") as? UIView
        if let label = viewTabBar?.subviews[safe: 1] as? UILabel {
          label.sizeToFit()
        }
      }
    }
  }

  func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController)
    -> Bool
  {
    if
      let index = viewControllers?.firstIndex(where: { $0 === viewController }),
      selectedIndex == index,
      let navViewController = viewController as? UINavigationController,
      let firstVC = navViewController.viewControllers.first as? ScrollableToTop
    {
      let scrollView = firstVC.scrollableToTopScrollView
      scrollView.scrollToTopForcingSearchBar()
    }

    return true
  }

  // MARK: Private

  private func popToRoot() {
    if let tabPresentedController = presentedViewController {
      tabPresentedController.dismiss(animated: false, completion: nil)
    }

    if let viewController = viewControllers?[safe: selectedIndex] {
      if let presentedViewController = viewController.presentedViewController {
        presentedViewController.dismiss(animated: false, completion: nil)
      }
      if let navViewController = viewController as? UINavigationController {
        navViewController.popToRootViewController(animated: false)
      }
    }
  }
}

// MARK: TabBarDeeplinkable

extension TabBarController: TabBarDeeplinkable {

  func selectSecondTab() -> AnyPublisher<TabBarDeeplinkable, Never> {
    popToRoot()
    selectedIndex = .love
    return Just(self)
      .eraseToAnyPublisher()
  }

  func makeSearchBarFirstResponder() -> AnyPublisher<TabBarDeeplinkable, Never> {
    popToRoot()
    selectedIndex = .main
    if let viewController = viewControllers?[safe: selectedIndex] as? NavigationController {
      if let vinchyViewController = viewController.topViewController as? SearchBarSelectable {
        vinchyViewController.searchBarBecomeFirstResponder()
      }
    }
    return Just(self)
      .eraseToAnyPublisher()
  }

  func openWineDetail(wineID: Int64) -> AnyPublisher<TabBarDeeplinkable, Never> {
    if let viewController = viewControllers?[safe: selectedIndex] as? NavigationController {
      viewController.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
    }
    return Just(self)
      .eraseToAnyPublisher()
  }
}

extension Int {
  fileprivate static let main = 0
  fileprivate static let love = 1
  fileprivate static let notes = 2
  fileprivate static let profile = 3
}
