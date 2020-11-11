//
//  AdvancedSearchInteractorProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol AdvancedSearchInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didSelectItem(at indexPath: IndexPath)
  func didTapShowAll(at section: Int)
  func didChooseCountryCodes(_ countryCodes: [String])
}
