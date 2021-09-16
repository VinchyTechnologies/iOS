//
//  MoreViewControllerProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/15/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import VinchyAuthorization

protocol MoreViewControllerProtocol: CantOpenURLAlertable, CantOpenEmailAlertable, AuthorizationOutputDelegate {
  func updateUI(viewModel: MoreViewControllerModel)
}
