//
//  NotesPresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import Foundation

protocol NotesPresenterProtocol: AnyObject {
  func update(notes: [VNote])
  func showAlert()
  func showEmpty(_ isEmpty: Bool)
  func hideEmpty()
}
