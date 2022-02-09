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


// MARK: - AdvancedSearchRoutable

public protocol AdvancedSearchRoutable: AnyObject {
  func presentAdvancedSearch(preselectedFilters: [(String, String)], isPriceFilterAvailable: Bool, delegate: AdvancedSearchOutputDelegate?)
}
