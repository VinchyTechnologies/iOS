//
//  FiltersInput.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import Foundation

public struct FiltersInput {
  public let preselectedFilters: [(String, String)]
  public init(preselectedFilters: [(String, String)]) {
    self.preselectedFilters = preselectedFilters
  }
}
