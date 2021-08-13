//
//  Document.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import StringFormatting

enum Document: CaseIterable {
  case termsOfUse

  // MARK: Internal

  var id: Int {
    switch self {
    case .termsOfUse:
      return 1
    }
  }

  var title: String {
    switch self {
    case .termsOfUse:
      return localized("terms_of_use_doc")
    }
  }

  var url: String {
    switch self {
    case .termsOfUse:
      return localized("terms_of_use_url")
    }
  }
}
