//
//  StoreViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

struct StoreViewModel {

  enum Section {
    case logo(LogoRow.Content)
    case title(Label.Content)
    case wines(BottlesCollectionView.Content)
    case assortiment([HorizontalWineView.Content])
//    case staticSelectedFilters([Label.Content])
  }

  let selectedFilters: [String]?
  let sections: [Section]

  static let empty: Self = .init(selectedFilters: nil, sections: [])
}
