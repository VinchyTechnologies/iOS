//
//  AdvancedSearchRouterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import VinchyUI

protocol AdvancedSearchRouterProtocol: ShowcaseRoutable {
  func presentAllCountries(preSelectedCountryCodes: [String])
  func dismiss(selectedFilters: [(String, String)])
}
