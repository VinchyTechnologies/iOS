//
//  WriteNotePresenterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import VinchyCore

protocol WriteNotePresenterProtocol: AnyObject {
  func setInitialNoteInfo(note: Note)
  func setInitialNoteInfo(wine: Wine)
}
