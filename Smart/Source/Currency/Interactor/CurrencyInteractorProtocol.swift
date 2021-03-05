//
//  CurrencyInteractorProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/1/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol CurrencyInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didTapCurrency(symbol: String)
}
