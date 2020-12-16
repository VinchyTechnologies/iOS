//
//  MorePresenterProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/15/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core

protocol MorePresenterProtocol: OpenURLProtocol {
  func startCreateViewModel()
  func showAlert(message: String) // TODO: - конкретный alert метод
//  func present(controller: UIViewController, completion: (() -> Void)?)
}
