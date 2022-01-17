//
//  ReviewsRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

// MARK: - ReviewsRoutable

extension WineDetailRoutable {
  func pushToReviewsViewController(wineID: Int64) {
    let controller = ReviewsAssembly.assemblyModule(input: .init(wineID: wineID), coordinator: Coordinator.shared)
    controller.hidesBottomBarWhenPushed = true
    UIApplication.topViewController()?.navigationController?.pushViewController(
      controller,
      animated: true)
  }
}
