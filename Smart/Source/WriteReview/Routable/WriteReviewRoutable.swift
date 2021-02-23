//
//  WriteReviewRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol WriteReviewRoutable: AnyObject {

  var viewController: UIViewController? { get }

  func presentWriteReviewViewController(
    reviewID: Int?,
    wineID: Int64,
    rating: Double,
    reviewText: String?)
}

extension WriteReviewRoutable {

  func presentWriteReviewViewController(
    reviewID: Int?,
    wineID: Int64,
    rating: Double,
    reviewText: String?)
  {
    viewController?.present(
      Assembly.buildWriteReviewViewController(
        reviewID: reviewID,
        wineID: wineID,
        rating: rating,
        reviewText: reviewText),
      animated: true,
      completion: nil)
  }
}
