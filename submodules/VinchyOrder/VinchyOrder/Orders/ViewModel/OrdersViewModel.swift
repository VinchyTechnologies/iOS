//
//  OrdersViewModel.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 20.02.2022.
//

import DisplayMini

struct OrdersViewModel {

  enum State {
    case normal(sections: [Section])
    case error(sections: [ErrorSection])
  }

  enum Section {
    case content(dataID: DataID, items: [Item])
  }

  enum Item {
    case order(content: OrderView.Content)
    case loading
  }

  enum ErrorSection {
    case common(content: EpoxyErrorView.Content)
  }

  enum DataID {
    case content
  }

  static let empty: Self = .init(
    state: .normal(sections: []),
    navigationTitle: nil)

  let state: State
  let navigationTitle: String?

}
