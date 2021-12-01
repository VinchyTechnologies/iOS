//
//  SimpleContinuosCarouselCollectionCellRouterProtocol.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import VinchyAuthorization
import VinchyCore
import VinchyUI

protocol SimpleContinuosCarouselCollectionCellRouterProtocol: WriteReviewRoutable, AuthorizationRoutable, ShowcaseRoutable, WineDetailRoutable {
  func pushToWriteViewController(note: VNote)
  func pushToWriteViewController(wine: Wine)
  func presentActivityViewController(items: [Any])
}
