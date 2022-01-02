//
//  EditProfileViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - EditProfileTextFieldType

enum EditProfileTextFieldType: String {
  case email
  case name
}

// MARK: - EditProfileViewModel

struct EditProfileViewModel {
  enum CommonEditCellRow {
    case title(text: NSAttributedString)
    case textField(model: CommonEditCollectionViewCellViewModel)
  }

  enum Section {
    case commonEditCell([CommonEditCellRow])
    case deleteAccount([LogOutCellViewModel])
  }

  let sections: [Section]
  let navigationTitle: String?
  let saveButtonText: String?
}
