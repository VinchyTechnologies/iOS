//
//  WriteNoteRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import VinchyCore

public protocol WriteNoteRoutable: AnyObject {
  func pushToWriteViewController(note: VNote)
  func presentWriteViewController(note: VNote)
  func pushToWriteViewController(wine: Wine)
  func presentWriteViewController(wine: Wine)
}
