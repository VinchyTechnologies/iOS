//
//  DeeplinkRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Combine

final class OpenWineDetailFlow: DeeplinkFlow<RootDeeplinkable> {
  
  struct Input {
    let wineID: Int64
  }
  
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
}

// MARK: - Router

protocol DeeplinkRouter {
  func route(url: URL)
}

final class DeeplinkRouterImpl {
  enum Flow {
    case openWineDetail(flow: OpenWineDetailFlow)
  }
  
  private var subscribtions: Set<AnyCancellable>?
  private let root: RootDeeplinkable
  
  init(root: RootDeeplinkable) {
    self.root = root
  }
  
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

extension DeeplinkRouterImpl: DeeplinkRouter {
  func route(url: URL) {
    switch createFlow(url: url) {
    case let .openWineDetail(flow):
      subscribtions = flow.subcscribe(root)
      
    case .none:
      ()
    }
  }
}
