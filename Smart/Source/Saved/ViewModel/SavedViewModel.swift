//
//  SavedViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

struct SavedViewModel {

  enum Section {
    case liked
//    case rates(content: Any)
  }

  let sections: [Section]
  let navigationTitleText: String?

  static let empty: Self = .init(sections: [], navigationTitleText: nil)
}
