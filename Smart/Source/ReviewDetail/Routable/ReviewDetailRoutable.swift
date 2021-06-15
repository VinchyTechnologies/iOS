//
//  ReviewDetailRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import FittedSheets
import UIKit

// MARK: - ReviewDetailRoutable

protocol ReviewDetailRoutable: AnyObject {
  var viewController: UIViewController? { get }

  func showBottomSheetReviewDetailViewController(reviewInput: ReviewDetailInput)
}

extension ReviewDetailRoutable {
  func showBottomSheetReviewDetailViewController(reviewInput: ReviewDetailInput) {
    guard let controller = viewController else {
      return
    }

    let options = SheetOptions(shrinkPresentingViewController: false)

    let reviewDetailViewController = ReviewDetailAssembly.assemblyModule(input: reviewInput)
    let sheet = SheetViewController(
      controller: reviewDetailViewController,
      sizes: [.percent(0.5), .fullscreen],
      options: options)

    controller.present(sheet, animated: true, completion: nil)
  }
}
