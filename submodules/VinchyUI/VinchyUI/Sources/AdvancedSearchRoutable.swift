//
//  AdvancedSearchRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - AdvancedSearchOutputDelegate

public protocol AdvancedSearchOutputDelegate: AnyObject {
  func didChoose(_ filters: [(String, String)])
}

// MARK: - AdvancedSearchInput

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

// MARK: - AdvancedSearchRoutable

public protocol AdvancedSearchRoutable: AnyObject {
  func presentAdvancedSearch(preselectedFilters: [(String, String)], delegate: AdvancedSearchOutputDelegate?)
}
