//
//  NotesInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol NotesInteractorProtocol: AnyObject {
  func viewWillAppear()
  func didEnterSearchText(_ searchText: String?)
  func didTapNoteCell(wineID: Int64)
  func didTapDeleteCell(wineID: Int64)
  func didTapConfirmDeleteCell(wineID: Int64)
}
