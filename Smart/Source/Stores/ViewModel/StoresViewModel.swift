//
//  StoresViewModel.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

struct StoresViewModel {
  enum SectionID {
    case title, partners, loading
  }

  enum ItemID: String {
    case titleItem, partnersItem, loadingItem
  }

  enum PartnersContent {
    case horizontalPartner(HorizontalPartnerView.Content)
  }

  enum Section {
    case title(itemID: ItemID = .titleItem, Label.Content)
    case partners(itemID: ItemID = .partnersItem, content: [PartnersContent])
    case loading(itemID: ItemID = .loadingItem)

    var dataID: SectionID {
      switch self {

      case .title:
        return .title

      case .partners:
        return .partners

      case .loading:
        return .loading
      }
    }
  }

  static let empty: Self = .init(sections: [], navigationTitleText: nil)

  let sections: [Section]
  let navigationTitleText: String?

}
