//
//  MoreRouterProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/15/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import VinchyUI

protocol MoreRouterProtocol: AuthorizationRoutable, ContactUsRoutable {
  func pushToDocController()
  func pushToCurrencyViewController()
  func pushToAboutController()
  func presentShowEditProfileViewController()
  func presentAlertAreYouSureLogout(titleText: String?, subtitleText: String?, leadingButtonText: String?, trailingButtonText: String?)
}
