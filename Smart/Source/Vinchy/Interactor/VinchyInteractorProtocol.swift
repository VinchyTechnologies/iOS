//
//  VinchyInteractorProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol VinchyInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didPullToRefresh()
  func didTapFilter()
  func didTapDidnotFindWineFromSearch(searchText: String?)
  func didTapSearchButton(searchText: String?)
  func didEnterSearchText(_ searchText: String?)
  func searchBarTextDidBeginEditing()
  func searchBarCancelButtonClicked()
  func didTapSuggestionCell(at indexPath: IndexPath)
  func didTapMapButton()
}
