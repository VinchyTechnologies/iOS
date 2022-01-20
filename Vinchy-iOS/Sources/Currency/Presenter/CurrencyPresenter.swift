//
//  CurrencyPresenter.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/1/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Display
import StringFormatting
import UIKit

// MARK: - CurrencyPresenter

final class CurrencyPresenter {

  // MARK: Lifecycle

  init(viewController: CurrencyViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: CurrencyViewControllerProtocol?

  func localizedString(forCurrencyCode currencyCode: String) -> String {
    let locale = NSLocale.current
    return (locale as NSLocale).displayName(forKey: NSLocale.Key.currencyCode, value: currencyCode) ?? ""
  }

  // MARK: Private

  private let currencyFilter = availableCurrencyCodes

  private func createViewModel(selectedCurrency: String) -> CurrencyViewControllerModel {
    var currenciesModels: [CurrencyCellViewModel] = []

    let currencies = allCurrencies().filter { currencyFilter.contains($0.code) }

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

// MARK: CurrencyPresenterProtocol

extension CurrencyPresenter: CurrencyPresenterProtocol {
  func update(selectedCurrency: String) {
    viewController?.update(viewModel: createViewModel(selectedCurrency: selectedCurrency))
  }
}
