//
//  Currency.swift
//  Core
//
//  Created by Алексей Смирнов on 01.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

public let availableCurrencyCodes = Set([
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
//      "IDR",
  "ILS",
  "INR",
//      "ISK",
//      "JPY",
//      "KRW",
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

var defaultCurrency: String = {
  if
    let localeCurrencyCode = Locale.current.currencyCode,
    availableCurrencyCodes.contains(localeCurrencyCode)
  {
    return localeCurrencyCode
  } else {
    return "USD"
  }
}()
