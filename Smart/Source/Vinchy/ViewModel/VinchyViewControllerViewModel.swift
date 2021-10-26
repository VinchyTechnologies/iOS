//
//  VinchyViewControllerViewModel.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct VinchyViewControllerViewModel {

  enum SectionID: Hashable {
    case fakemini, faketitle
  }

  enum FakeItemID: String, Hashable {
    case mini, title
  }

  enum State {
    case fake(sections: [FakeSection])
    case normal(sections: [Section])
  }

  enum Section {
//    case title([TextCollectionCellViewModel])
//    case stories([SimpleContinuousCaruselCollectionCellViewModel])
//    case promo([SimpleContinuousCaruselCollectionCellViewModel])
//    case big([SimpleContinuousCaruselCollectionCellViewModel])
    case bottles(content: [WineBottleView.Content])
//    case shareUs([ShareUsCollectionCellViewModel])
//    case smartFilter([SmartFilterCollectionCellViewModel])
//    case storeTitle([StoreTitleCollectionCellViewModel])
  }

  enum FakeSection {
    case stories(itemID: FakeItemID, content: FakeVinchyCollectionCellViewModel)
    case promo(itemID: FakeItemID, content: FakeVinchyCollectionCellViewModel)
    case title(itemID: FakeItemID, content: FakeVinchyCollectionCellViewModel)
    case big(itemID: FakeItemID, content: FakeVinchyCollectionCellViewModel)
  }

  static let empty: Self = .init(state: .fake(sections: []), leadingAddressButtonViewModel: .loading(text: nil))

  let state: State
  let leadingAddressButtonViewModel: DiscoveryLeadingAddressButtonMode
}
