//
//  ResultsSearchViewModel.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini

struct ResultsSearchViewModel {

  enum Section {
    case title(content: Label.Content)
    case recentlySearched(content: BottlesCollectionView.Content)
    case horizontalWine(content: HorizontalWineView.Content)
    case didnotFindWine(content: DidnotFindTheWineView.Content)
  }

  static let empty: Self = .init(sections: [])

  let sections: [Section]
}
