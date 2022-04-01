//
//  RootBuilder.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - RootBuilderInput

struct RootBuilderInput {
  let window: UIWindow
}

// MARK: - RootBuilder

protocol RootBuilder {
  func build(input: RootBuilderInput) -> RootInteractor & RootDeeplinkable
}

// MARK: - RootBuilderImpl

final class RootBuilderImpl: RootBuilder {

  // MARK: Lifecycle

  init(tabBarBuilder: TabBarBuilder, splashService: SplashService) {
    self.tabBarBuilder = tabBarBuilder
    self.splashService = splashService
  }

  // MARK: Internal

  func build(input: RootBuilderInput) -> RootInteractor & RootDeeplinkable {
    let router = RootRouterImpl(window: input.window, tabBarBuilder: tabBarBuilder)
    let interactor = RootInteractorImpl(router: router, splashService: splashService)
    return interactor
  }

  // MARK: Private

  private let tabBarBuilder: TabBarBuilder
  private let splashService: SplashService
}
