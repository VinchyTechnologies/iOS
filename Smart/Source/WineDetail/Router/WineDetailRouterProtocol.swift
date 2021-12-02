//
//  WineDetailRouterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import Display
import Sheeeeeeeeet
import VinchyAuthorization
import VinchyCore
import VinchyUI

protocol WineDetailRouterProtocol: WineDetailRoutable, ReviewsRoutable, ReviewDetailRoutable, WriteReviewRoutable, AuthorizationRoutable, ActivityRoutable, WriteNoteRoutable, ContactUsRoutable {
  func presentActivityViewController(items: [Any], button: UIButton)
  func showMoreActionSheet(menuItems: [MenuItem], appearance: ActionSheetAppearance, button: UIButton)
  func presentStore(affilatedId: Int)
  func pushToSeeAllStores(wineID: Int64)
}
