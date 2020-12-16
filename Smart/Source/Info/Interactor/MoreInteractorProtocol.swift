//
//  MoreInteractorProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/15/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

protocol MoreInteractorProtocol: AnyObject {
  func viewDidLoad()
  func sendEmail(HTMLText: String?)
  func callUs()
  func rateApp()
  func openVk()
  func openInstagram()
  func emailUs()
  func workWithUs()
  func goToDocController()
  func goToAboutController()
}
