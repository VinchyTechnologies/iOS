//
//  DeeplinkRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Combine
import Foundation

// MARK: - OpenGlobalSearchFlow

final class OpenGlobalSearchFlow: DeeplinkFlow<RootDeeplinkable> {

  override init() {
    super.init()
    onStep { root in
      root.openTabBar()
    }
    .onStep { tabBar in
      tabBar.makeSearchBarFirstResponder()
    }
    .commit()
  }

  // MARK: Internal
}

// MARK: - OpenSecondTabFlow

final class OpenSecondTabFlow: DeeplinkFlow<RootDeeplinkable> {

  override init() {
    super.init()
    onStep { root in
      root.openTabBar()
    }
    .onStep { tabBar in
      tabBar.selectSecondTab()
    }
    .commit()
  }

  // MARK: Internal
}

// MARK: - OpenWineDetailFlow

final class OpenWineDetailFlow: DeeplinkFlow<RootDeeplinkable> {

  // MARK: Lifecycle

  init(input: Input) {
    super.init()
    onStep { root in
      root.openTabBar()
    }
    .onStep { tabBar in
      tabBar.openWineDetail(wineID: input.wineID)
    }
    .commit()
  }

  // MARK: Internal

  struct Input {
    let wineID: Int64
  }
}

// MARK: - OpenStoreFlow

final class OpenStoreFlow: DeeplinkFlow<RootDeeplinkable> {

  // MARK: Lifecycle

  init(input: Input) {
    super.init()
    onStep { root in
      root.openTabBar()
    }
    .onStep { tabBar in
      tabBar.openStoreDetail(affilatedId: input.affilatedId)
    }
    .commit()
  }

  // MARK: Internal

  struct Input {
    let affilatedId: Int
  }
}

// MARK: - ShowcaseFlow

final class ShowcaseFlow: DeeplinkFlow<RootDeeplinkable> {

  // MARK: Lifecycle

  init(input: Input) {
    super.init()
    onStep { root in
      root.openTabBar()
    }
    .onStep { tabBar in
      tabBar.openShowcase(collectionID: input.collectionID)
    }
    .commit()
  }

  // MARK: Internal

  struct Input {
    let collectionID: Int
  }
}

// MARK: - DeeplinkRouter

protocol DeeplinkRouter {
  func route(url: URL)
}

// MARK: - DeeplinkRouterImpl

final class DeeplinkRouterImpl {

  // MARK: Lifecycle

  init(root: RootDeeplinkable) {
    self.root = root
  }

  // MARK: Internal

  enum Flow {
    case openWineDetail(flow: OpenWineDetailFlow)
    case openSecondTabBarItem(flow: OpenSecondTabFlow)
    case openGlobalSearch(flow: OpenGlobalSearchFlow)
    case openStore(flow: OpenStoreFlow)
    case openShowcase(flow: ShowcaseFlow)
  }

  // MARK: Private

  private var subscribtions: Set<AnyCancellable>?
  private let root: RootDeeplinkable

  private func createFlow(url: URL) -> Flow? {
    if url.absoluteString == "vinchy://search" {
      return .openGlobalSearch(flow: .init())
    }

    if url.absoluteString == "vinchy://secondTab" {
      return .openSecondTabBarItem(flow: .init())
    }

    guard !url.pathComponents.isEmpty else { return nil }
    if
      let word = url.pathComponents[safe: url.pathComponents.count - 2]
    {
      if word == "wines" {
        guard
          let id = url.pathComponents.last,
          let wineID = Int64(id)
        else { return nil }
        return .openWineDetail(flow: OpenWineDetailFlow(input: .init(wineID: wineID)))

      } else if word == "store" {
        guard
          let id = url.pathComponents.last,
          let affilatedId = Int(id)
        else { return nil }
        return .openStore(flow: OpenStoreFlow(input: .init(affilatedId: affilatedId)))

      } else if word == "list" {
        guard
          let id = url.pathComponents.last,
          let collectionID = Int(id)
        else { return nil }
        return .openShowcase(flow: ShowcaseFlow(input: .init(collectionID: collectionID)))
      }
    }
    return nil
  }
}

// MARK: DeeplinkRouter

extension DeeplinkRouterImpl: DeeplinkRouter {
  func route(url: URL) {
    switch createFlow(url: url) {
    case .openWineDetail(let flow):
      subscribtions = flow.subcscribe(root)

    case .openSecondTabBarItem(let flow):
      subscribtions = flow.subcscribe(root)

    case .openGlobalSearch(let flow):
      subscribtions = flow.subcscribe(root)

    case .openStore(let flow):
      subscribtions = flow.subcscribe(root)

    case .openShowcase(let flow):
      subscribtions = flow.subcscribe(root)

    case .none:
      ()
    }
  }
}
