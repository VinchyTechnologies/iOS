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
  
  weak var viewController: CurrencyViewControllerProtocol?

  // MARK: - Private Properties
  
  private let currencyFilter = Set(
    [
      "AUD",
      "BGN",
      "BRL",
      "CAD",
      "CHF",
      "CNY",
      "CZK",
      "DKK",
      "GBR",
      "HKD",
      "HRK",
      "HUF",
      "IDR",
      "ILS",
      "INR",
      "ISK",
      "JPY",
      "KRW",
      "MXN",
      "MYR",
      "NOK",
      "NZD",
      "PHP",
      "PLN",
      "RON",
      "RUB",
      "SEK",
      "SGD",
      "THB",
      "TRY",
      "USD",
      "ZAR",
    ])
  
  // MARK: - Initializers
  
  init(viewController: CurrencyViewControllerProtocol) {
    self.viewController = viewController
  }
  
  // MARK: - Private Methods
  
  func localizedString(forCurrencyCode currencyCode: String) -> String {
    let locale = NSLocale.current
    return (locale as NSLocale).displayName(forKey: NSLocale.Key.currencyCode, value: currencyCode) ?? ""
  }  
  
  private func createViewModel(selectedCurrency: String) -> CurrencyViewControllerModel {
    var currenciesModels: [CurrencyCellViewModel] = []

    let currencies = allCurrencies().filter({ currencyFilter.contains($0.code) })
    
    for currency in currencies {
      let isSelected = currency.code == selectedCurrency
      let model = CurrencyCellViewModel(
        title: localizedString(forCurrencyCode: currency.code).firstLetterUppercased() + " - " + currency.symbol,
        isSelected: isSelected,
        code: currency.code)
      currenciesModels.append(model)
    }
    return CurrencyViewControllerModel(
      navigationTitle: localized("select_currency").firstLetterUppercased(),
      currencies: currenciesModels)
  }
}
extension CurrencyPresenter: CurrencyPresenterProtocol {
  
  func update(selectedCurrency: String) {
    viewController?.update(viewModel: createViewModel(selectedCurrency: selectedCurrency))
  }
}
