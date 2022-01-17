//
//  ReviewsInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol ReviewsInteractorProtocol: AnyObject {
  func viewDidLoad()
  func willDisplayLoadingView()
  func didSelectReview(id: Int)
}
