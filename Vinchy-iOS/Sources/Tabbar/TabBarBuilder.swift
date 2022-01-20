//
//  TabBarBuilder.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - TabBarBuilder

protocol TabBarBuilder {
  func build() -> UIViewController & TabBarDeeplinkable
}

// MARK: - TabBarBuilderImpl

final class TabBarBuilderImpl: TabBarBuilder {
  func build() -> UIViewController & TabBarDeeplinkable {
    TabBarController()
  }
}
