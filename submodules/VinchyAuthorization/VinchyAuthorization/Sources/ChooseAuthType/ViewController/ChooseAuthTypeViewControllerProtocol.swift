//
//  ChooseAuthTypeViewControllerProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import Display
import Core

protocol ChooseAuthTypeViewControllerProtocol: Alertable, OpenURLProtocol {
  func updateUI(viewModel: ChooseAuthTypeViewModel)
}
