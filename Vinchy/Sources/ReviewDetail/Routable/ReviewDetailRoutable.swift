//
//  ReviewDetailRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import FittedSheets
import UIKit
import VinchyUI

// MARK: - ReviewDetailRoutable

extension ReviewDetailRoutable {
  func showBottomSheetReviewDetailViewController(reviewInput: ReviewDetailInput) {
    let options = SheetOptions(shrinkPresentingViewController: false)
    let reviewDetailViewController = ReviewDetailAssembly.assemblyModule(input: reviewInput)
    let sheet = SheetViewController(
      controller: reviewDetailViewController,
      sizes: [.percent(0.5), .fullscreen],
      options: options)

    sheet.handleScrollView(reviewDetailViewController.scrollView)
    if reviewDetailViewController.traitCollection.userInterfaceStyle == .dark {
      sheet.gripColor = .blueGray
    }

    UIApplication.topViewController()?.present(sheet, animated: true, completion: nil)
  }
}
