//
//  ResultsSearchRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 02.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - ResultsSearchRoutable

public protocol ResultsSearchRoutable: AnyObject {
  func pushToResultsSearchController(affilatedId: Int, resultsSearchDelegate: ResultsSearchDelegate?)
}

// MARK: - ResultsSearchDelegate

public protocol ResultsSearchDelegate: AnyObject {
  func didTapBottleCell(wineID: Int64)
  func didTapSearchButton(searchText: String?)
}
