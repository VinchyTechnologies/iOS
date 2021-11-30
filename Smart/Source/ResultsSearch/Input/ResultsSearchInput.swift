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
    case storeDetail(affilatedId: Int)
  }

  init(mode: Mode) {
    self.mode = mode
  }

  let mode: Mode
}
