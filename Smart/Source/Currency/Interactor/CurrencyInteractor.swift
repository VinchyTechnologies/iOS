//
//  CurrencyInteractor.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/1/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core

final class CurrencyInteractor {
  
  var presenter: CurrencyPresenterProtocol
  
  private let router: CurrencyRouterProtocol
  
  init(presenter: CurrencyPresenterProtocol, router: CurrencyRouterProtocol) {
    self.presenter = presenter
    self.router = router
  }
}

extension CurrencyInteractor: CurrencyInteractorProtocol {

  func viewDidLoad() {
    presenter.update(selectedCurrency: UserDefaultsConfig.currency)
  }
  
  func didTapCurrency(symbol: String) {
    UserDefaultsConfig.currency = symbol
    presenter.update(selectedCurrency: symbol)
  }
}
