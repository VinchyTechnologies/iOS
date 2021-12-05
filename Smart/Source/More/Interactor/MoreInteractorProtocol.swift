//
//  MoreInteractorProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/15/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import UIKit.UIView

protocol MoreInteractorProtocol: AnyObject, OpenURLProtocol {
  func viewDidLoad()
  func didTapCallUs()
  func didTapRateApp()
  func didTapCurrency()
  func didTapOpenInstagram()
  func didTapOpenTelegram()
  func didTapOpenFacebook()
  func didTapEmailUs(sourceView: UIView)
  func didTapworkWithUs(sourceView: UIView)
  func didTapDoc()
  func didTapAboutApp()
  func didTapProfile()
  func didTapLogout()
  func didTapLogoutOnAlert()
}
