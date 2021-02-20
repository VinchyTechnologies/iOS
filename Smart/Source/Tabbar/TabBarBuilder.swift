//
//  TabBarBuilder.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

protocol TabBarBuilder {
  func build() -> UIViewController & TabBarDeeplinkable
}

final class TabBarBuilderImpl: TabBarBuilder {
  func build() -> UIViewController & TabBarDeeplinkable {
    TabBarController()
  }
}
