//
//  WineDetailViewControllerProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display

protocol WineDetailViewControllerProtocol: Alertable, Loadable {
  func updateUI(viewModel: WineDetailViewModel)
}
