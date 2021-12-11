//
//  SearchViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import DisplayMini
import UIKit
import VinchyCore

// MARK: - SearchViewController

final class SearchViewController: UISearchController {

  // MARK: Lifecycle

  override init(searchResultsController: UIViewController?) {
    super.init(searchResultsController: searchResultsController)
    showsSearchResultsController = true
    obscuresBackgroundDuringPresentation = false
    searchBar.autocapitalizationType = .none
    searchBar.searchTextField.font = Font.medium(20)
    searchBar.searchTextField.layer.cornerRadius = 20
    searchBar.searchTextField.layer.masksToBounds = true
    searchBar.searchTextField.layer.cornerCurve = .continuous
    searchBar.delegate = searchResultsController as? UISearchBarDelegate
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  var interactor: SearchInteractorProtocol?

}

// MARK: SearchViewControllerProtocol

extension SearchViewController: SearchViewControllerProtocol {}

// MARK: DidnotFindTheWineCollectionCellProtocol

extension SearchViewController: DidnotFindTheWineCollectionCellProtocol {
  func didTapWriteUsButton(_ button: UIButton) {
    let searchText = searchBar.searchTextField.text
    interactor?.didTapDidnotFindWineFromSearch(
      searchText: searchText, sourceView: button)
  }
}
