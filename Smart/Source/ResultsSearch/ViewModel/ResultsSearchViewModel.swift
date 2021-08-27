//
//  ResultsSearchViewModel.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct ResultsSearchViewModel {
  enum State {
    case results(sections: [ResultsSection])
    case history(sections: [HistorySection])
  }

  enum ResultsSection {
    case searchResults([WineCollectionCellViewModel])
    case didNotFindTheWine([DidnotFindTheWineCollectionCellViewModel])
  }

  enum HistorySection {
    case titleRecentlySearched([TextCollectionCellViewModel])
    case recentlySearched([WineCollectionViewCellViewModel])
  }

  let state: State
}
