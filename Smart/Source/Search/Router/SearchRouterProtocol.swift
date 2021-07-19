//
//  SearchRouterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

protocol SearchRouterProtocol: ShowcaseRoutable {
  func pushToDetailCollection(searchText: String)
}
