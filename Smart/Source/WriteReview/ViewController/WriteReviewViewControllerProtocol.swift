//
//  WriteReviewViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

protocol WriteReviewViewControllerProtocol: Alertable, Loadable {
  func setPlaceholder(placeholder: String?)
  func updateUI(viewModel: WriteReviewViewModel)
  func setSendButtonEnabled(_ flag: Bool)
}
