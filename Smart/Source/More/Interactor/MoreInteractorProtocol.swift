//
//  MoreInteractorProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/15/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core

protocol MoreInteractorProtocol: AnyObject, OpenURLProtocol {
  func viewDidLoad()
  func didTapSendEmail(HTMLText: String?)
  func didTapCallUs()
  func didTapRateApp()
  func didTapCurrency()
  func didTapOpenVk()
  func didTapOpenInstagram()
  func didTapEmailUs()
  func didTapworkWithUs()
  func didTapDoc()
  func didTapAboutApp()
  func didTapProfile()
  func didTapLogout()
  func didTapLogoutOnAlert()
}
