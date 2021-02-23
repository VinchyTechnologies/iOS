//
//  WriteReviewPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class WriteReviewPresenter {
    
  weak var viewController: WriteReviewViewControllerProtocol?
  
  init(viewController: WriteReviewViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - WriteReviewPresenterProtocol

extension WriteReviewPresenter: WriteReviewPresenterProtocol {
  
  func update(rating: Double, comment: String?) {
    viewController?.updateUI(rating: rating, comment: comment)
  }
  
  func setPlaceholder() {
    viewController?.setPlaceholder(placeholder: "placeholder")
  }
}
