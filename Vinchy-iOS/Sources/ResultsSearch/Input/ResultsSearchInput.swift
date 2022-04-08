//
//  ResultsSearchInput.swift
//  Smart
//
//  Created by Алексей Смирнов on 29.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

struct ResultsSearchInput {
  enum Mode {
    case normal
    case storeDetail(affilatedId: Int, currencyCode: String?)
  }

  init(mode: Mode, shouldHideNavigationController: Bool) {
    self.mode = mode
    self.shouldHideNavigationController = shouldHideNavigationController
  }

  let mode: Mode
  let shouldHideNavigationController: Bool
}
