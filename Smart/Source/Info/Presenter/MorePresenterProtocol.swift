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
  
  func startCreateViewModel()
  func showOpenEmailErrorAlert()
  func showOpenURLErrorAlert()
  func showURLContactUs()
}
