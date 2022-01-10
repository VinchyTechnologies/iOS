//
//  WriteNoteInteractorProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import UIKit.UIView

protocol WriteNoteInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didTapSave()
  func didChangeNoteText(_ text: String?)
  func didStartWriteText()
  func didTapClose(text: String?, barButtonItem: UIBarButtonItem?)
  func didTapSaveOnAlert(text: String?)
  func didTapDeleteNote(note: VNote)
}
