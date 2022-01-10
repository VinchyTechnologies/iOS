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

  var areYouSureToSaveTitleText: String? { get }
  var cancelText: String? { get }
  var saveText: String? { get }

  var deleteTitleText: String? { get }
  var subtitleDeleteText: String? { get }
  var deleteConfirmText: String? { get }

  func setInitialNoteInfo(note: VNote)
  func setInitialNoteInfo(wine: Wine)
  func setPlaceholder()
  func setSaveButtonActive(_ flag: Bool)
}
