//
//  StoreViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol StoreViewControllerProtocol: AnyObject {
  func updateUI(viewModel: StoreViewModel)
}
