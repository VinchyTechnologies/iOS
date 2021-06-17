//
//  VinchyPresenterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

protocol VinchyPresenterProtocol: AnyObject {
  var cantFindWineText: String { get }
  var cantFindWineRecipients: [String] { get }

  func update(compilations: [Compilation], isSearchingMode: Bool)
  func update(suggestions: [Wine])
  func update(didFindWines: [ShortWine])
  func showAlertCantOpenEmail()
  func startShimmer()
  func stopPullRefreshing()
  func showAlertEmptyCollection()
}
