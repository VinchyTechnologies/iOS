//
//  WriteNoteViewControllerProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//
import Display

protocol WriteNoteViewControllerProtocol: AnyObject {
  func update(viewModel: WriteNoteViewModel)
  func setupPlaceholder(placeholder: String?)
}
