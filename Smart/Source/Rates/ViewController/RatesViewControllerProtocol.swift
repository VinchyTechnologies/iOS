//
//  RatesViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display

protocol RatesViewControllerProtocol: Alertable {
  func updateUI(viewModel: RatesViewModel)
  func updateUI(errorViewModel: ErrorViewModel)
  func stopPullRefreshing()
}
