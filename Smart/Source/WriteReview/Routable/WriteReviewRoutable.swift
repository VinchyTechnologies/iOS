//
//  WriteReviewRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

// MARK: - WriteReviewRoutable

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
    let controller = WriteReviewAssembly.assemblyModule(
      input: .init(reviewID: reviewID, wineID: wineID, rating: rating, comment: reviewText ?? ""))
    let navController = NavigationController(rootViewController: controller)
    viewController?.present(
      navController,
      animated: true,
      completion: nil)
  }
}
