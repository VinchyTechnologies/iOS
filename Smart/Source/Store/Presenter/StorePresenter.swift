//
//  StorePresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - StorePresenter

final class StorePresenter {

  // MARK: Lifecycle

  init(viewController: StoreViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: StoreViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = StoreViewModel

}

// MARK: StorePresenterProtocol

extension StorePresenter: StorePresenterProtocol {

}
