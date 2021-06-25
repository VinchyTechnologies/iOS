//
//  NotesPresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database

// MARK: - NotesEmptyType

enum NotesEmptyType {
  case isEmpty, noFound
}

// MARK: - NotesPresenterProtocol

protocol NotesPresenterProtocol: AnyObject {
  func update(notes: [VNote])
  func showDeletingAlert(wineID: Int64)
  func showEmpty(type: NotesEmptyType)
  func hideEmpty()
}
