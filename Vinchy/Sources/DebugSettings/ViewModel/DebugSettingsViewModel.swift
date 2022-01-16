//
//  DebugSettingsViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 14.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

struct DebugSettingsViewModel {

  enum Section {
    case navigateVinchyStore(TextRow.Content)
    case navigateToPushNotification(TextRow.Content)
  }

  let sections: [Section]
  let navigationTitleText: String?

  static let empty: Self = .init(sections: [], navigationTitleText: nil)
}
