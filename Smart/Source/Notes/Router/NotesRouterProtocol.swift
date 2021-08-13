//
//  NotesRouterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import Foundation

protocol NotesRouterProtocol: AnyObject {
  func pushToWriteViewController(note: VNote)
}
