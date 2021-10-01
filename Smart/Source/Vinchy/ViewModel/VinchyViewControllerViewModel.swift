//
//  VinchyViewControllerViewModel.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct VinchyViewControllerViewModel {
  enum State {
    case fake(sections: [FakeSection])
    case normal(sections: [Section])
  }

  enum Section {
    case title([TextCollectionCellViewModel])
    case stories([SimpleContinuousCaruselCollectionCellViewModel])
    case promo([SimpleContinuousCaruselCollectionCellViewModel])
    case big([SimpleContinuousCaruselCollectionCellViewModel])
    case bottles([SimpleContinuousCaruselCollectionCellViewModel])
    case shareUs([ShareUsCollectionCellViewModel])
    case smartFilter([SmartFilterCollectionCellViewModel])
    case storeTitle([StoreTitleCollectionCellViewModel])
  }

  enum FakeSection {
    case stories(FakeVinchyCollectionCellViewModel)
    case promo(FakeVinchyCollectionCellViewModel)
    case title(FakeVinchyCollectionCellViewModel)
    case big(FakeVinchyCollectionCellViewModel)
  }

  let state: State
  let city: String?
}
