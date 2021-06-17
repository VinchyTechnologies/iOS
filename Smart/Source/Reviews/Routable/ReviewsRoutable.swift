//
//  ReviewsRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - ReviewsRoutable

protocol ReviewsRoutable: AnyObject {
  var viewController: UIViewController? { get }

  func pushToReviewsViewController(wineID: Int64)
}

extension WineDetailRoutable {
  func pushToReviewsViewController(wineID: Int64) {
    let controller = ReviewsAssembly.assemblyModule(input: .init(wineID: wineID))
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(
      controller,
      animated: true)
  }
}
