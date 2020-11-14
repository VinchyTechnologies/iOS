//
//  AdvancedSearchRouterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol AdvancedSearchRouterProtocol: AnyObject {
  func presentAllCountries(preSelectedCountryCodes: [String])
  func pushToSearchResultsController(navigationTitle: String?, params: [(String, String)])
}
