//
//  ShowcaseViewControllerProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display

protocol ShowcaseViewControllerProtocol: Alertable, Loadable {
  func updateUI(viewModel: ShowcaseViewModel)
  func updateUI(errorViewModel: ErrorViewModel)
  func updateMoreLoader(shouldLoadMore: Bool)
}
