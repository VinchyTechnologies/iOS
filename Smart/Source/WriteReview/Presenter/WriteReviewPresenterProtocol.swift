//
//  WriteReviewPresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol WriteReviewPresenterProtocol: AnyObject {
  func setPlaceholder()
  func update(rating: Double, comment: String?)
  
}
