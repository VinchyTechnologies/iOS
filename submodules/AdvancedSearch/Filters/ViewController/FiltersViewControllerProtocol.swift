//
//  FiltersViewControllerProtocol.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import Foundation

protocol FiltersViewControllerProtocol: AnyObject {
  func updateUI(viewModel: FiltersViewModel, reloadingData: Bool)
}
