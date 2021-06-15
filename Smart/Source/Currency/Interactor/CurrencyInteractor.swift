//
//  CurrencyInteractor.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/1/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core

// MARK: - CurrencyInteractor

final class CurrencyInteractor {

  // MARK: Lifecycle

  init(presenter: CurrencyPresenterProtocol, router: CurrencyRouterProtocol) {
    self.presenter = presenter
    self.router = router
  }

  // MARK: Private

  private let presenter: CurrencyPresenterProtocol
  private let router: CurrencyRouterProtocol
}

// MARK: CurrencyInteractorProtocol

extension CurrencyInteractor: CurrencyInteractorProtocol {
  func viewDidLoad() {
    presenter.update(selectedCurrency: UserDefaultsConfig.currency)
  }

  func didTapCurrency(symbol: String) {
    UserDefaultsConfig.currency = symbol
    presenter.update(selectedCurrency: symbol)
  }
}
