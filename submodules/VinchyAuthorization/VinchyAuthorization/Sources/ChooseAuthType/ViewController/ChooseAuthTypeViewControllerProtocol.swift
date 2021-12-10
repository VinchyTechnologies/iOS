//
//  ChooseAuthTypeViewControllerProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import Core
import DisplayMini

protocol ChooseAuthTypeViewControllerProtocol: Alertable, OpenURLProtocol {
  func updateUI(viewModel: ChooseAuthTypeViewModel)
}
