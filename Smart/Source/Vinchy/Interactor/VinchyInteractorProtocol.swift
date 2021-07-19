//
//  VinchyInteractorProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol VinchyInteractorProtocol: VinchySimpleConiniousCaruselCollectionCellDelegate {
  func viewDidLoad()
  func didPullToRefresh()
  func didTapFilter()
  func didTapDidnotFindWineFromSearch(searchText: String?)
  func didSelectResultCell(wineID: Int64, title: String)
  func didTapMapButton()
}
