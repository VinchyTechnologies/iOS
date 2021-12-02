//
//  ReviewDetailRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 02.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - ReviewDetailInput

public struct ReviewDetailInput {
  public let rate: Double?
  public let author: String?
  public let date: String?
  public let reviewText: String?

  public init(rate: Double?, author: String?, date: String?, reviewText: String?) {
    self.rate = rate
    self.author = author
    self.date = date
    self.reviewText = reviewText
  }
}

// MARK: - ReviewDetailRoutable

public protocol ReviewDetailRoutable: AnyObject {
  func showBottomSheetReviewDetailViewController(reviewInput: ReviewDetailInput)
}
