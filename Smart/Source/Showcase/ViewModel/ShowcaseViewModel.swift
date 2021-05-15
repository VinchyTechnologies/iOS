//
//  CategoryItem.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 18.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct ShowcaseViewModel {
  
  enum Section {
    case shelf(title: String?, wines: [WineCollectionViewCellViewModel])
  }
  
  let navigationTitle: String?
  let sections: [Section]
}
