//
//  NotesInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol NotesInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didEnterSearchText(_ searchText: String?)
}
