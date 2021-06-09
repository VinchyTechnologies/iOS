//
//  MapDetailStoreViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

protocol MapDetailStoreViewControllerProtocol: Loadable {
  func updateUI(viewModel: MapDetailStoreViewModel)
}
