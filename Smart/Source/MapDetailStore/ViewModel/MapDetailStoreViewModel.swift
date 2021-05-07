//
//  MapDetailStoreViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct MapDetailStoreViewModel {
  enum Section {
    case title([TextCollectionCellViewModel])
  }
  
  let sections: [Section]
}
