//
//  NotesViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Combine
import Display

protocol NotesViewControllerProtocol: Alertable {
  func updateUI(viewModel: NotesViewModel)
  func hideEmptyView()
  func showEmptyView(title: String, subtitle: String)

  @discardableResult
  func showAlert(wineID: Int64, title: String, firstActionTitle: String, secondActionTitle: String, message: String?) -> AnyPublisher<Void, Never>
}
