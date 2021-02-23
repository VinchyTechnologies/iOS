//
//  WriteReviewPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import StringFormatting

final class WriteReviewPresenter {
    
  let input: WriteReviewInput
  weak var viewController: WriteReviewViewControllerProtocol?
  
  init(input: WriteReviewInput, viewController: WriteReviewViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - WriteReviewPresenterProtocol

extension WriteReviewPresenter: WriteReviewPresenterProtocol {
  
  func update(rating: Double, comment: String?) {
    let navigationTitle = input.reviewID == nil
      ? localized("write_review").firstLetterUppercased()
      : localized("update_review").firstLetterUppercased()
    viewController?.updateUI(viewModel: .init(rating: rating, reviewText: comment, navigationTitle: navigationTitle))
  }
  
  func setPlaceholder() {
    viewController?.setPlaceholder(placeholder: localized("review_placeholder"))
  }
}
