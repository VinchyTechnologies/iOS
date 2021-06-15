//
//  MapDetailStoreViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct MapDetailStoreViewModel {
  enum Row {
    case title(TextCollectionCellViewModel)
    case address(TextCollectionCellViewModel)
    case workingHours(WorkingHoursCollectionCellViewModel)
    case assortment(AssortmentCollectionCellViewModel)
    case recommendedWines(VinchySimpleConiniousCaruselCollectionCellViewModel)
  }

  enum Section {
    case content(header: MapNavigationBarCollectionCellViewModel, items: [Row])
  }

  let sections: [Section]
}
