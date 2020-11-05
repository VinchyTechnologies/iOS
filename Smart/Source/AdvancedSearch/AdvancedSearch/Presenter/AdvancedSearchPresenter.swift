//
//  AdvancedSearchPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class AdvancedSearchPresenter {
  
  private typealias ViewModel = AdvancedSearchViewModel
  
  weak var viewController: AdvancedSearchViewControllerProtocol?
  
  init(viewController: AdvancedSearchViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - AdvancedSearchPresenterProtocol

extension AdvancedSearchPresenter: AdvancedSearchPresenterProtocol {
  
}
