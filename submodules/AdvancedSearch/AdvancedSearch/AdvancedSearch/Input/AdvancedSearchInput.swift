//
//  AdvancedSearchInput.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public struct AdvancedSearchInput {
  public enum Mode {
    case normal
    case asView(preselectedFilters: [(String, String)])
  }

  public let mode: Mode

  public init(mode: Mode) {
    self.mode = mode
  }
}
