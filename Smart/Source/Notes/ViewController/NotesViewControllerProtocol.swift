//
//  NotesViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Foundation

protocol NotesViewControllerProtocol: Alertable {
  func updateUI(viewModel: NotesViewModel)
}
