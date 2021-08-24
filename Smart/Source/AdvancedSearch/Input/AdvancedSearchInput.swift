//
//  AdvancedSearchInput.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

struct AdvancedSearchInput {
  enum Mode {
    case normal
    case asView(preselectedFilters: [(String, String)])
  }

  let mode: Mode
}
