//
//  SearchViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol SearchViewControllerProtocol: AnyObject {
  func updateUI(viewModel: SearchViewModel)
}
