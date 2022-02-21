//
//  OrderDetailViewModel.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 21.02.2022.
//

import DisplayMini

struct OrderDetailViewModel {
  enum Section {
    case title(content: Label.Content)
    case orderItem(OrderItemView.Content)
    case orderNumber(OrderDateStatusView.Content)
    case logo(LogoRow.Content)
    case address(StoreMapRow.Content)
  }

  let sections: [Section]
  let navigationTitleText: String?
  let bottomBarViewModel: BottomPriceBarView.Content?

  static let empty: Self = .init(sections: [], navigationTitleText: nil, bottomBarViewModel: nil)
}
