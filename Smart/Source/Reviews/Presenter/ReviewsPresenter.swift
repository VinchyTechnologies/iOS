//
//  ReviewsPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import StringFormatting

final class ReviewsPresenter {
  
  private typealias ViewModel = ReviewsViewModel
  
  weak var viewController: ReviewsViewControllerProtocol?
  
  init(viewController: ReviewsViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - ReviewsPresenterProtocol

extension ReviewsPresenter: ReviewsPresenterProtocol {
  
  func showInitiallyLoadingError(error: Error) {
    viewController?.updateUI(
      errorViewModel: ErrorViewModel(
        titleText: localized("error").firstLetterUppercased(),
        subtitleText: error.localizedDescription,
        buttonText: localized("reload").firstLetterUppercased()))
  }
  
  func showErrorAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }
  
  func startShimmer() {
    viewController?.updateUI(viewModel: .init(state: .fake(sections: [
      .review(Array(repeating: 1, count: 20))
    ]), navigationTitle: "Reviews"))
  }
  
  func update(reviews: [Any], needLoadMore: Bool) {
    
    let model = ReviewCellViewModel.init(id: 1, userNameText: "aleksei_smirnov", dateText: "29.08.21", reviewText: "lkdsjbvlhkbjs", rate: 4.5)
    
    var items: [ReviewsViewModel.Item] = Array.init(repeating: ReviewsViewModel.Item.review(model), count: reviews.count)
    
    if needLoadMore {
      items.append(.loading)
    }
    
    let viewModel = ReviewsViewModel(state: .normal(items: items), navigationTitle: "Reviews")
    viewController?.updateUI(viewModel: viewModel)
  }
}
