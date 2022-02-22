//
//  TabBarController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 16.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Combine
import DisplayMini
import StringFormatting
import UIKit
import VinchyStore
import WineDetail

// MARK: - TabBarDeeplinkable

protocol TabBarDeeplinkable {
  func openWineDetail(wineID: Int64) -> AnyPublisher<TabBarDeeplinkable, Never>
  func openStoreDetail(affilatedId: Int) -> AnyPublisher<TabBarDeeplinkable, Never>
  func openShowcase(collectionID: Int) -> AnyPublisher<TabBarDeeplinkable, Never>
  func selectSecondTab() -> AnyPublisher<TabBarDeeplinkable, Never>
  func makeSearchBarFirstResponder() -> AnyPublisher<TabBarDeeplinkable, Never>
  func openSavedStores(isEditingWidget: Bool) -> AnyPublisher<TabBarDeeplinkable, Never>
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

    UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
    UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)

    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .mainBackground
//    appearance.shadowImage = nil
//    appearance.shadowColor = .mainBackground
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

    let main = buildMainModule()
    main.tabBarItem = UITabBarItem(
      title: localized("explore").firstLetterUppercased(),
      image: UIImage(systemName: "square.grid.2x2", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal),
      selectedImage: UIImage(systemName: "square.grid.2x2", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal))

    let love = VinchyNavigationController(rootViewController: SavedAssembly.assemblyModule(input: .init())) //Assembly.buildLoveModule()
    love.tabBarItem = UITabBarItem(
      title: localized("favourites").firstLetterUppercased(),
      image: UIImage(systemName: "heart", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal),
      selectedImage: UIImage(systemName: "heart", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal))

    let notes = VinchyNavigationController(rootViewController: NotesAssembly.assemblyModule())
    notes.tabBarItem = UITabBarItem(
      title: localized("notes").firstLetterUppercased(),
      image: UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal),
      selectedImage: UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal))

    let profile = buildProfileModule()
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

    let map = buildMapViewController()
    map.tabBarItem = UITabBarItem(
      title: localized("map").firstLetterUppercased(),
      image: UIImage(systemName: "map", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal),
      selectedImage: UIImage(systemName: "map", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal))
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
      selectedIndex == index
    {
      if
        let navViewController = viewController as? UINavigationController,
        let firstVC = navViewController.viewControllers.first as? ScrollableToTop
      {
        let scrollView = firstVC.scrollableToTopScrollView
        scrollView.scrollToTopForcingSearchBar()
      }

      if let endIndex = viewControllers?.endIndex, index == endIndex - 1 {
        let timestamp = CACurrentMediaTime()
        if debugTapCounter.0 < timestamp - 0.4 {
          debugTapCounter.0 = timestamp
          debugTapCounter.1 = 0
        }

        if debugTapCounter.0 >= timestamp - 0.4 {
          debugTapCounter.0 = timestamp
          debugTapCounter.1 += 1
        }

        if debugTapCounter.1 >= 10 {
          debugTapCounter.1 = 0
          openDebugSettings()
          return false
        }
      }
    }

    return true
  }

  // MARK: Private

  private var debugTapCounter: (Double, Int) = (0.0, 0)

  private func buildProfileModule() -> VinchyNavigationController {
    let controller = MoreAssembly.assemblyModule()
    let navController = VinchyNavigationController(rootViewController: controller)
    return navController
  }

  private func openDebugSettings() {
    if let viewController = viewControllers?.last {
      selectedIndex = .profile
      let controller = DebugSettingsAssembly.assemblyModule()
      controller.hidesBottomBarWhenPushed = true
      (viewController as? VinchyNavigationController)?.pushViewController(
        controller,
        animated: true)
    }
  }

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

  private func buildMainModule() -> VinchyNavigationController {
    let controller = VinchyAssembly.assemblyModule()
    let navController = VinchyNavigationController(rootViewController: controller)
    return navController
  }

  private func buildMapViewController() -> UIViewController {
    let controller = MapAssembly.assemblyModule()
    controller.hidesBottomBarWhenPushed = true
    return controller
  }
}

// MARK: TabBarDeeplinkable

extension TabBarController: TabBarDeeplinkable {

  func openSavedStores(isEditingWidget: Bool) -> AnyPublisher<TabBarDeeplinkable, Never> {
    let controller = StoresAssembly.assemblyModule(input: .init(mode: .saved(isEditingWidget: isEditingWidget)))
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .overFullScreen
    UIApplication.topViewController(base: self)?.present(
      navigationController,
      animated: true,
      completion: nil)
    return Just(self)
      .eraseToAnyPublisher()
  }

  func openShowcase(collectionID: Int) -> AnyPublisher<TabBarDeeplinkable, Never> {
    let controller = ShowcaseAssembly.assemblyModule(input: .init(title: nil, mode: .remote(collectionID: collectionID)))
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .overFullScreen
    UIApplication.topViewController(base: self)?.present(
      navigationController,
      animated: true,
      completion: nil)
    return Just(self)
      .eraseToAnyPublisher()
  }

  func openStoreDetail(affilatedId: Int) -> AnyPublisher<TabBarDeeplinkable, Never> {
    let controller = StoreAssembly.assemblyModule(input: .init(mode: .normal(affilatedId: affilatedId), isAppClip: false), coordinator: Coordinator.shared, adFabricProtocol: AdFabric.shared)
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .overFullScreen
    UIApplication.topViewController(base: self)?.present(
      navigationController,
      animated: true,
      completion: nil)
    return Just(self)
      .eraseToAnyPublisher()
  }

  func selectSecondTab() -> AnyPublisher<TabBarDeeplinkable, Never> {
    popToRoot()
    selectedIndex = .love
    return Just(self)
      .eraseToAnyPublisher()
  }

  func makeSearchBarFirstResponder() -> AnyPublisher<TabBarDeeplinkable, Never> {
    popToRoot()
    selectedIndex = .main
    if let viewController = viewControllers?[safe: selectedIndex] as? VinchyNavigationController {
      if let vinchyViewController = viewController.topViewController as? SearchBarSelectable {
        vinchyViewController.searchBarBecomeFirstResponder()
      }
    }
    return Just(self)
      .eraseToAnyPublisher()
  }

  func openWineDetail(wineID: Int64) -> AnyPublisher<TabBarDeeplinkable, Never> {
    let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID, mode: .normal, isAppClip: false, shouldShowSimilarWine: true), coordinator: Coordinator.shared, adGenerator: AdFabric.shared)
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .overFullScreen
    UIApplication.topViewController(base: self)?.present(
      navigationController,
      animated: true,
      completion: nil)
    return Just(self)
      .eraseToAnyPublisher()
  }
}

extension Int {
  fileprivate static let main = 0
  fileprivate static let love = 1
  fileprivate static let map = 2
  fileprivate static let notes = 3
  fileprivate static let profile = 4
}

extension UITabBar {
  // Workaround for iOS 11's new UITabBar behavior where on iPad, the UITabBar inside
  // the Master view controller shows the UITabBarItem icon next to the text
  override open var traitCollection: UITraitCollection {
    if UIDevice.current.userInterfaceIdiom == .pad {
      return UITraitCollection(horizontalSizeClass: .compact)
    }
    return super.traitCollection
  }
}
