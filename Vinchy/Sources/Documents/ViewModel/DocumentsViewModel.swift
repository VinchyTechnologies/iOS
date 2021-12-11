//
//  DocumentsViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

struct DocumentsViewModel {

  enum Section {
    case urlDocument(TextRow.Content)
  }

  let sections: [Section]
  let navigationTitleText: String?

  static let empty: Self = .init(sections: [], navigationTitleText: nil)
}
