//
//  EditProfileViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

struct EditProfileViewModel {
  enum CommonEditCellRow {
    case title(text: NSAttributedString)
    case textField(text: String?)
  }

  enum Section {
    case commonEditCell([CommonEditCellRow])
  }

  let sections: [Section]
  let navigationTitle: String?
  let saveButtonText: String?
}
