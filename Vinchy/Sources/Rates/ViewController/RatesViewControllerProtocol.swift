//
//  RatesViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini

protocol RatesViewControllerProtocol: Alertable, Loadable {
  func updateUI(viewModel: RatesViewModel)
  func stopPullRefreshing()
}
