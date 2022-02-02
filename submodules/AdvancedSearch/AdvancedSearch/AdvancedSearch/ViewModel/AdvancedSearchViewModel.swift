//
//  AdvancedSearchViewModel.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import DisplayMini

public struct AdvancedSearchViewModel {
  enum Section {
    case carusel(headerViewModel: AdvancedHeaderViewModel, items: [AdvancedSearchCaruselCollectionCellViewModel])
    case price(headerViewModel: AdvancedHeaderViewModel, items: [MinMaxPriceCellViewModel])
  }

  let sections: [Section]
  let navigationTitle: String?
  let bottomButtonsViewModel: BottomButtonsViewModel
  let isBottomButtonsViewHidden: Bool
}
