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
  enum Section {
    case shelf(title: String?, wines: [WineCollectionViewCellViewModel])
    case loading
  }

  let navigationTitle: String?
  let sections: [Section]
  let tabViewModel: TabViewModel
}
