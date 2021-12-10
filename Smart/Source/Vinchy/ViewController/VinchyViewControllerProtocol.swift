//
//  VinchyViewControllerProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import VinchyCore

protocol VinchyViewControllerProtocol: Alertable, ScrollableToTop {
  func updateUI(viewModel: VinchyViewControllerViewModel)
  func stopPullRefreshing()
}
