//
//  ReviewDetailPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyUI

// MARK: - ReviewDetailPresenter

final class ReviewDetailPresenter {

  // MARK: Lifecycle

  init(input: ReviewDetailInput, viewController: ReviewDetailViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: ReviewDetailViewControllerProtocol?

  // MARK: Private

  private let input: ReviewDetailInput
}

// MARK: ReviewDetailPresenterProtocol

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
