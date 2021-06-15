//
//  MorePresenterProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/15/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core

protocol MorePresenterProtocol: OpenURLProtocol {
  var sendEmailRecipients: [String] { get }
  var phoneURL: String { get }

  func update(isRussianLocale: Bool, currency: String)
  func showAlertCantOpenEmail()
  func showOpenURLErrorAlert()
}
