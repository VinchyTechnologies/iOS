//
//  VinchyViewControllerProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import VinchyCore

protocol VinchyViewControllerProtocol: Loadable, Alertable {
  func updateUI(viewModel: VinchyViewControllerViewModel)
  func stopPullRefreshing()
}
