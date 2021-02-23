//
//  WriteReviewViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol WriteReviewViewControllerProtocol: AnyObject {
  func setPlaceholder(placeholder: String?)
  func updateUI(rating: Double, comment: String?)
}
