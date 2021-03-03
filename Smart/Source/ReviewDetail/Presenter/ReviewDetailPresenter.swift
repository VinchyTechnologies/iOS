//
//  ReviewDetailPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class ReviewDetailPresenter {
    
  weak var viewController: ReviewDetailViewControllerProtocol?
  private let input: ReviewDetailInput
  
  init(input: ReviewDetailInput, viewController: ReviewDetailViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - ReviewDetailPresenterProtocol

extension ReviewDetailPresenter: ReviewDetailPresenterProtocol {
  func update() {
    let viewModel = ReviewDetailViewModel(
      rate: input.rate,
      authorText: input.author,
      dateText: input.date,
      reviewText: input.reviewText)
    viewController?.updateUI(viewModel: viewModel)
  }
}
