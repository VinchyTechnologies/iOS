//
//  StoresPresenter.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - StoresPresenter

final class StoresPresenter {

  // MARK: Lifecycle

  init(viewController: StoresViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: StoresViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = StoresViewModel
}

// MARK: StoresPresenterProtocol

extension StoresPresenter: StoresPresenterProtocol {}
