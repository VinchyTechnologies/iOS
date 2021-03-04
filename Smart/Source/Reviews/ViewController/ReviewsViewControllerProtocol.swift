//
//  ReviewsViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display

protocol ReviewsViewControllerProtocol: Alertable {
  func updateUI(viewModel: ReviewsViewModel)
  func updateUI(errorViewModel: ErrorViewModel)
}
