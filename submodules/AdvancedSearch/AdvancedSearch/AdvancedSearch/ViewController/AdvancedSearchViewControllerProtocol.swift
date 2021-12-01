//
//  AdvancedSearchViewControllerProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public protocol AdvancedSearchViewControllerProtocol: AnyObject {
  func updateUI(viewModel: AdvancedSearchViewModel, sec: Int?)
}
