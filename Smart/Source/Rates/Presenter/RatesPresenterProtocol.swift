//
//  RatesPresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

protocol RatesPresenterProtocol: AnyObject {
  func startShimmer()
  func update(reviews: [ReviewedWine], needLoadMore: Bool, wasUsedRefreshControl: Bool)
  func showErrorAlert(error: Error)
  func showInitiallyLoadingError(error: Error)
}
