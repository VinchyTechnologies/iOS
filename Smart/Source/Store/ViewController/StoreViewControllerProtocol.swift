//
//  StoreViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display

protocol StoreViewControllerProtocol: Loadable, Alertable {
  func updateUI(viewModel: StoreViewModel)
  func updateUI(errorViewModel: ErrorViewModel)
}
