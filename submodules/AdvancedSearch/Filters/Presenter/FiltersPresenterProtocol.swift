//
//  FiltersPresenterProtocol.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import Core

protocol FiltersPresenterProtocol: AnyObject {
  func update(filters: [Filter], selectedFilters: [(String, String)], reloadingData: Bool)
}
