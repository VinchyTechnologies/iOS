//
//  CartViewModel.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import DisplayMini

struct CartViewModel {

  enum Section {
    case title(content: Label.Content)
    case cartItem(CartItemView.Content)
    case logo(LogoRow.Content)
    case address(StoreMapRow.Content)
  }

  let sections: [Section]
  let navigationTitleText: String?
  let bottomBarViewModel: BottomPriceBarView.Content?

  static let empty: Self = .init(sections: [], navigationTitleText: nil, bottomBarViewModel: nil)
}
