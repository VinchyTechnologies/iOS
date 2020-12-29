//
//  VinchyRouterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

protocol VinchyRouterProtocol: WineDetailRoutable {
  func pushToAdvancedFilterViewController()
  func pushToDetailCollection(searchText: String)
  func presentEmailController(HTMLText: String?, recipients: [String])
  func pushToShowcaseViewController(navigationTitle: String?, wines: [ShortWine])
}
