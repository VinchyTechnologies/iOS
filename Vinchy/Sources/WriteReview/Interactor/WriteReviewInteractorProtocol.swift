//
//  WriteReviewInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol WriteReviewInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didTapSend(rating: Double, comment: String?)
  func didChangeContent(comment: String?, rating: Double?)
}
