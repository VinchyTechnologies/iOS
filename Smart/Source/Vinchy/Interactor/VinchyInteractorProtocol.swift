//
//  VinchyInteractorProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol VinchyInteractorProtocol: VinchySimpleConiniousCaruselCollectionCellDelegate, ResultsSearchDelegate {
  func viewDidLoad()
  func didPullToRefresh()
  func didTapFilter()
  func didTapMapButton()
}
