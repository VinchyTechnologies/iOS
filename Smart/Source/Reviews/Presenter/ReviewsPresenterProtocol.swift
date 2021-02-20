//
//  ReviewsPresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol ReviewsPresenterProtocol: AnyObject {
  func startShimmer()
  func update(reviews: [Any], needLoadMore: Bool)
  func showErrorAlert(error: Error)
  func showInitiallyLoadingError(error: Error)
}
