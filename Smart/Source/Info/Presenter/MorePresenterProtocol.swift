//
//  MorePresenterProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/15/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol MorePresenterProtocol: AnyObject {
  func startCreateViewModel()
  func showAlert(message: String)
  func present(controller: UIViewController, completion: (() -> Void)?)
}
