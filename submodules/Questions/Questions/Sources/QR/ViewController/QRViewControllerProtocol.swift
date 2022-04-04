//
//  QRViewControllerProtocol.swift
//  Questions
//
//  Created by Алексей Смирнов on 13.03.2022.
//

import DisplayMini

protocol QRViewControllerProtocol: Loadable, Alertable {
  func updateUI(viewModel: QRViewModel)
  func updateUI(errorViewModel: ErrorViewModel)
}
