//
//  NotesViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

struct NotesViewModel {

  enum Section {
    case simpleNote([WineTableCellViewModel])
  }

  let sections: [Section]
  let navigationTitleText: String?
  let titleForDeleteConfirmationButton: String?
}
