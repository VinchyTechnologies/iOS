//
//  CurrencyPresenter.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/1/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Core
import StringFormatting
import Display

final class CurrencyPresenter {
  
  // MARK: - Internal Properties
  
   var viewController: CurrencyViewControllerProtocol?
  var selectedCurrency: String?
  
  // MARK: - Initializers
  
  init(viewController: CurrencyViewControllerProtocol) {
    self.viewController = viewController
  }
  
  // MARK: - Private Methods
  
  let currencyFilter = Set(["AUD","BGN","BRL","CAD","CHF","CNY","CZK","DKK","GBR","HKD","HRK","HUF","IDR","ILS","INR","ISK",
                           "JPY","KRW","MXN","MYR","NOK","NZD","PHP","PLN","RON","RUB","SEK","SGD","THB","TRY","USD",
                           "ZAR"])
  
  private func createViewModel() -> [CurrencyCellViewModel] {
    var currenciesModels: [CurrencyCellViewModel] = []
    let currencies = allCurrencies().filter( {currencyFilter.contains($0)} )

    for currency in currencies {
      let isSelected = currency == selectedCurrency
      let model = CurrencyCellViewModel(currency: currency, selected: isSelected)
      currenciesModels.append(model)
    }
    return currenciesModels
  }
}
extension CurrencyPresenter: CurrencyPresenterProtocol {
  
  func update(selectedCurrency: String) {
    self.selectedCurrency = selectedCurrency
    viewController?.update(models: createViewModel())
  }
}
