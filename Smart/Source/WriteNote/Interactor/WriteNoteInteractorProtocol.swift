//
//  WriteNoteInteractorProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

protocol WriteNoteInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didTapSave()
  func didChangeNoteText(_ text: String?)
  func didStartWriteText()
}
