//
//  MoreViewProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/15/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

protocol MoreViewProtocol: AnyObject {
  func presentAlert(message: String)
  func updateUI(viewModel: MoreViewControllerModel)
}
