//
//  WriteReviewRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 02.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public protocol WriteReviewRoutable: AnyObject {
  func presentWriteReviewViewController(
    reviewID: Int?,
    wineID: Int64,
    rating: Double,
    reviewText: String?)
}
