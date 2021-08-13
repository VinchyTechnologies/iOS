//
//  WineDetailRouterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import Sheeeeeeeeet
import VinchyAuthorization
import VinchyCore

protocol WineDetailRouterProtocol: WineDetailRoutable, ReviewsRoutable, ReviewDetailRoutable, WriteReviewRoutable, AuthorizationRoutable {
  func presentActivityViewController(items: [Any], button: UIButton)
  func pushToWriteViewController(note: VNote)
  func pushToWriteViewController(wine: Wine)
  func presentEmailController(HTMLText: String?, recipients: [String])
  func showMoreActionSheet(menuItems: [MenuItem], appearance: ActionSheetAppearance, button: UIButton)
  func presentStore(affilatedId: Int)
}
