//
//  CategoryItem.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 18.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

struct CategoryItem: Decodable {
  
  let title: String?
  var wines: [ShortWine]
}
