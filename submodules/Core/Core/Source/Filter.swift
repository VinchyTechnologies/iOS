//
//  Filter.swift
//  Core
//
//  Created by Aleksei Smirnov on 20.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - Filter

public final class Filter: Decodable {

  // MARK: Lifecycle

  public init(category: FilterCategory, items: [FilterItem]) {
    self.category = category
    self.items = items
  }

  // MARK: Public

  public let category: FilterCategory
  public var items: [FilterItem]
}

// MARK: - FilterCategory

public enum FilterCategory: String, Decodable {
  case type, color, country, sugar

  public var serverName: String {
    switch self {
    case .type:
      return "carbon_dioxide"

    case .color:
      return "color"

    case .country:
      return "country_code"

    case .sugar:
      return "sugar"
    }
  }
}

// MARK: - FilterItem

public struct FilterItem: Decodable, Equatable {
  public let title: String
  public let imageName: String?
  public let category: FilterCategory

  public init(title: String, imageName: String?, category: FilterCategory) {
    self.title = title
    self.imageName = imageName
    self.category = category
  }
}

public func loadFilters() -> [Filter] {
  guard let filePath = Bundle.main.path(forResource: "filters", ofType: "json") else {
    return []
  }

  guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
    return []
  }

  return try! JSONDecoder().decode([Filter].self, from: data) // swiftlint:disable:this force_try
}
