//
//  FiltersInput.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import Foundation

public struct FiltersInput {
  public let preselectedFilters: [(String, String)]
  public let isPriceFilterAvailable: Bool
  public let currencyCode: String?
  public let affiliedId: Int

  public init(preselectedFilters: [(String, String)], isPriceFilterAvailable: Bool, currencyCode: String?, affiliedId: Int) {
    self.preselectedFilters = preselectedFilters
    self.isPriceFilterAvailable = isPriceFilterAvailable
    self.currencyCode = currencyCode
    self.affiliedId = affiliedId
  }
}
