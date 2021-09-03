//
//  StoreRouterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyAuthorization

protocol StoreRouterProtocol: WineDetailRoutable, ActivityRoutable, ShowcaseRoutable, WriteNoteRoutable, WriteReviewRoutable, AuthorizationRoutable {
  func presentFilter(preselectedFilters: [(String, String)])
}
