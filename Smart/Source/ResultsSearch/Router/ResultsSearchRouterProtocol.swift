//
//  ResultsSearchRouterProtocol.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

protocol ResultsSearchRouterProtocol: ShowcaseRoutable {
  func pushToDetailCollection(searchText: String)
}
