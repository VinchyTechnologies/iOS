//
//  AddressSearchViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

struct AddressSearchViewModel {

  enum Section {
    case address(TextRow.Content)
    case currentGeo(TextRow.Content)
  }

  let sections: [Section]
  let navigationTitleText: String?

  static let empty: Self = .init(sections: [], navigationTitleText: nil)

}
