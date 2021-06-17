//
//  DeeplinkRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Combine

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
  }

  // MARK: Private

  private var subscribtions: Set<AnyCancellable>?
  private let root: RootDeeplinkable

  private func createFlow(url: URL) -> Flow? {
    guard !url.pathComponents.isEmpty else { return nil }
    if
      let word = url.pathComponents[safe: url.pathComponents.count - 2],
      word == "wines"
    {
      guard
        let id = url.pathComponents.last,
        let wineID = Int64(id)
      else { return nil }
      return .openWineDetail(flow: OpenWineDetailFlow(input: .init(wineID: wineID)))

    } else {
      return nil
    }
  }
}

// MARK: DeeplinkRouter

extension DeeplinkRouterImpl: DeeplinkRouter {
  func route(url: URL) {
    switch createFlow(url: url) {
    case .openWineDetail(let flow):
      subscribtions = flow.subcscribe(root)

    case .none:
      ()
    }
  }
}
