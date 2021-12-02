//
//  ReviewsRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 02.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

public protocol ReviewsRoutable: AnyObject {
  func pushToReviewsViewController(wineID: Int64)
}
