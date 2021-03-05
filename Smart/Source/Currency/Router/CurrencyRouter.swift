//
//  CurrencyRouter.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/1/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class CurrencyRouter: CurrencyRouterProtocol {
  
  weak var viewController: CurrencyViewController?
  
  init(viewController: CurrencyViewController) {
    self.viewController = viewController
  }
}
