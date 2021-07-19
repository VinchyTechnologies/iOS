//
//  SearchPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Database
import Display
import UIKit
import VinchyCore

// MARK: - SearchPresenter

final class SearchPresenter {

  // MARK: Lifecycle

  init(viewController: SearchViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: SearchViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = SearchViewModel

}

// MARK: SearchPresenterProtocol

extension SearchPresenter: SearchPresenterProtocol {
  func update(didFindWines: [ShortWine]) {
    viewController?.updateUI(didFindWines: didFindWines)
  }
  func update(searched: [VSearchedWine]) {
    var sections: [SearchViewModel.Section] = []
    var wineCollectionViewCellViewModels: [WineCollectionViewCellViewModel] = []
    searched.forEach { wine in
      wineCollectionViewCellViewModels.append(.init(wineID: wine.wineID, imageURL: imageURL(from: wine.wineID).toURL, titleText: wine.title, subtitleText: nil))
    }
    if !wineCollectionViewCellViewModels.isEmpty {
      sections.append(.title(
        [.init(titleText: NSAttributedString(
          string: "Вы недавно искали",
          font: Font.heavy(20),
          textColor: .dark))]
      ))
    }
    sections.append(.recentlySearched(wineCollectionViewCellViewModels.reversed()))
    viewController?.updateUI(viewModel: SearchViewModel(sections: sections))
  }
}
