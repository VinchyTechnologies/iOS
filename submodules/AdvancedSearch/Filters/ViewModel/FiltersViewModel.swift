//
//  FiltersViewModel.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import DisplayMini

struct FiltersViewModel {

  enum Section {
    case title(content: Label.Content)
    case countryTitle(content: TitleAndMoreView.Content)
    case carousel(dataID: String, content: ServingTipsCollectionView.Content)
  }

  let sections: [Section]
  let navigationTitleText: String?
  let bottomBarViewModel: BottomButtonsView.Content?

  static let empty: Self = .init(sections: [], navigationTitleText: nil, bottomBarViewModel: nil)
}
