//
//  WriteReviewRouterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyAuthorization
import Display


protocol WriteReviewRouterProtocol: DismissRoutable, AuthorizationRoutable {
  func dismissAfterUpdate(statusAlertViewModel: StatusAlertViewModel)
  func dismissAfterCreate(statusAlertViewModel: StatusAlertViewModel)
}
