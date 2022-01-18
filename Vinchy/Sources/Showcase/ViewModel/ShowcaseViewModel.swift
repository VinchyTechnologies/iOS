//
//  CategoryItem.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 18.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import DisplayMini

struct ShowcaseViewModel {

  enum State {
    case normal(header: TabViewModel, sections: [Section])
    case error(sections: [ErrorSection])
  }

  enum Section {
    case content(dataID: DataID, items: [Item])
  }

  enum Item {
    case title(itemID: AnyHashable, content: Label.Content)
    case bottle(itemID: AnyHashable, content: WineBottleView.Content)
    case loading
  }

  enum ErrorSection {
    case common(content: EpoxyErrorView.Content)
  }

  enum DataID {
    case content
  }

  static let empty: Self = .init(
    state: .normal(header: .init(items: [], initiallySelectedIndex: 0), sections: []),
    navigationTitle: nil,
    isSharable: false)

  let state: State
  let navigationTitle: String?
  let isSharable: Bool
}
