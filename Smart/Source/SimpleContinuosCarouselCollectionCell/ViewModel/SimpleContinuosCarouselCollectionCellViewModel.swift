//
//  SimpleContinuosCarouselCollectionCellViewModel.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import VinchyCore

struct SimpleContinuousCaruselCollectionCellViewModel: ViewModelProtocol {
  let type: CollectionType
  let collections: [Collection]

  public init(type: CollectionType, collections: [Collection]) {
    self.type = type
    self.collections = collections
  }
}
