//
//  WineDetailRouterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import DisplayMini
import UIKit
import VinchyCore
import VinchyUI

protocol WineDetailRouterProtocol: WineDetailRoutable, ReviewsRoutable, ReviewDetailRoutable, WriteReviewRoutable, AuthorizationRoutable, ActivityRoutable, WriteNoteRoutable, ContactUsRoutable, StoresRoutable, StoreRoutable, WineShareRoutable, StatusAlertable, ShowcaseRoutable, SafariRoutable {
  func showMoreActionSheet(reportAnErrorText: String?, button: UIButton)
}
