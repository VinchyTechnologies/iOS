//
//  MainCoordinator.swift
//  Smart
//
//  Created by Aleksei Smirnov on 29.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
  
  // MARK: - Private Properties
  
  private let moduleFactory = MainModuleFactory()
  private let window: UIWindow
  
  // MARK: - Initializers
  
  init(window: UIWindow) {
    self.window = window
  }
  
  // MARK: - Public Methods
  
  func start() {
    let viewController = moduleFactory.makeTabbarController()
    window.setRootViewController(viewController, options: .init(direction: .toBottom, style: .easeInOut))
  }
}
