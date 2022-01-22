//
//  WriteReviewInput.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

struct WriteReviewInput {
  let reviewID: Int?
  let wineID: Int64
  let rating: Double?
  let comment: String
}
