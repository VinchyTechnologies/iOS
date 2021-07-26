//
//  ResultsSearchPresenterProtocol.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import VinchyCore

protocol ResultsSearchPresenterProtocol: AnyObject {
  func update(searched: [VSearchedWine])
  func update(didFindWines: [ShortWine])
}
