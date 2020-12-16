//
//  MoreRouterProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/15/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol MoreRouterProtocol: AnyObject {
  func present(_ viewController: UIViewController, completion: (() -> Void)?)
  func pushToDocController()
  func pushToAboutController()
}
