//
//  ResultsSearchViewControllerProtocol.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import VinchyCore

protocol ResultsSearchViewControllerProtocol: AnyObject {
  func updateUI(viewModel: ResultsSearchViewModel)
}
