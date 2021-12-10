//
//  AreYouInStoreViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini

struct AreYouInStoreViewModel {

  enum Section {
    case title([TextCollectionCellViewModel])
    case recommendedWines([SimpleContinuousCaruselCollectionCellViewModel])
  }

  let sections: [Section]
  let bottomButtonsViewModel: BottomButtonsViewModel
}
