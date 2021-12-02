//
//  DocumentsViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import WineDetail // TODO: - remove

protocol DocumentsViewControllerProtocol: CantOpenURLAlertable {
  func updateUI(viewModel: DocumentsViewModel)
}
