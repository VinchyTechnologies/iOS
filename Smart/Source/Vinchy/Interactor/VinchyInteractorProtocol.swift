//
//  VinchyInteractorProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import VinchyUI

protocol VinchyInteractorProtocol: ResultsSearchDelegate, WineViewContextMenuTappable {
  func viewDidLoad()
  func didPullToRefresh()
  func didTapFilter()
  func didTapMapButton()
  func didTapBottleCell(wineID: Int64)
  func didTapCompilationCell(input: ShowcaseInput)
  func didTapSeeStore(affilatedId: Int)
  func didTapChangeAddressButton()
  func didChangeAddress()
}
