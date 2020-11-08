//
//  AdvancedSearchViewModel.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct AdvancedSearchViewModel {

  enum Section {
    case carusel(headerViewModel: AdvancedHeaderViewModel, items: [AdvancedSearchCaruselCollectionCellViewModel])
  }

  let sections: [Section]
  let navigationTitle: String?
  
}
