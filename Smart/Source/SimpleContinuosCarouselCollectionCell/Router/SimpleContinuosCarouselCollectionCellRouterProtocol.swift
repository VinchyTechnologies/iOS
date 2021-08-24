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

protocol SimpleContinuosCarouselCollectionCellRouterProtocol: WriteReviewRoutable, AuthorizationRoutable, ShowcaseRoutable, WineDetailRoutable, WriteNoteRoutable {
  func presentActivityViewController(items: [Any])
}
