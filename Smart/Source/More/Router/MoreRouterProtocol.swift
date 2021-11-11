//
//  MoreRouterProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/15/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import VinchyAuthorization

protocol MoreRouterProtocol: AuthorizationRoutable {
  func present(_ viewController: UIViewController, completion: (() -> Void)?)
  func presentEmailController(HTMLText: String?, recipients: [String])
  func pushToDocController()
  func pushToCurrencyViewController()
  func pushToAboutController()
  func presentShowEditProfileViewController()
  func presentAlertAreYouSureLogout(titleText: String?, subtitleText: String?, leadingButtonText: String?, trailingButtonText: String?)
  func presentContactActionSheet(to: String, subject: String, body: String, includingThirdPartyApps: Bool, sourceView: UIView)
}
