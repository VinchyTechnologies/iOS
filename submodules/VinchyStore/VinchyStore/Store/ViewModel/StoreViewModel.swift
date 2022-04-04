//
//  StoreViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini

struct StoreViewModel {

  enum SectionID {
    case logo, title, wines, winesSection, staticSelectedFilters, separator, assortiment, address, loading, services, button
  }

  enum ItemID: String {
    case logoItem, titleItem, addressItem, winesItem, headerAssortimentItem, loadingItem, ad, strongFilters
  }

  enum AssortimentContent {
    case horizontalWine(HorizontalWineView.Content)
    case contentCoulBeNotRight(content: Label.Content)
    case ad(itemID: ItemID = .ad)
    case empty(itemID: ItemID, content: EmptyView.Content)
  }

  enum Section {
    case logo(itemID: ItemID = .logoItem, LogoRow.Content)
    case title(itemID: ItemID = .titleItem, Label.Content)
    case address(itemID: ItemID = .addressItem, StoreMapRow.Content)
    case button(content: ButtonView.Content)
    case services(ServicesButtonView.Content)
    case wines(itemID: ItemID = .winesItem, BottlesCollectionView.Content)
    case assortiment(headerDataID: ItemID = .headerAssortimentItem, header: FiltersCollectionView.Content, content: [AssortimentContent])
    case loading(itemID: ItemID = .loadingItem, shouldCallWillDisplay: Bool)

    // MARK: Internal

    var dataID: SectionID {
      switch self {
      case .logo:
        return .logo

      case .button:
        return .button

      case .title:
        return .title

      case .address:
        return .address

      case .wines:
        return .wines

      case .assortiment:
        return .assortiment

      case .loading:
        return .loading

      case .services:
        return .services
      }
    }
  }

  static let empty: Self = .init(
    sections: [],
    navigationTitleText: nil,
    shouldResetContentOffset: false,
    isLiked: false,
    bottomPriceBarViewModel: nil)

  let sections: [Section]
  let navigationTitleText: String?
  let shouldResetContentOffset: Bool
  var isLiked: Bool
  let bottomPriceBarViewModel: BottomPriceBarView.Content?

}
