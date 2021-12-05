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
import UIKit
import VinchyCore
import VinchyUI

protocol WineDetailRouterProtocol: WineDetailRoutable, ReviewsRoutable, ReviewDetailRoutable, WriteReviewRoutable, AuthorizationRoutable, ActivityRoutable, WriteNoteRoutable, ContactUsRoutable, StoresRoutable, StoreRoutable {
  func showMoreActionSheet(menuItems: [MenuItem], appearance: ActionSheetAppearance, button: UIButton)
}
