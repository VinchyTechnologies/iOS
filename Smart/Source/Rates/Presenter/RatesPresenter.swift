//
//  RatesPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import StringFormatting
import VinchyCore

// MARK: - RatesPresenter

final class RatesPresenter {

  // MARK: Lifecycle

  init(viewController: RatesViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: RatesViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = RatesViewModel
}

// MARK: RatesPresenterProtocol

extension RatesPresenter: RatesPresenterProtocol {
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
//    viewController?.updateUI(viewModel: .init(state: .fake(sections: [
//      .review(Array(repeating: 1, count: 20)),
//    ]), navigationTitle: localized("reviews").firstLetterUppercased()))
  }

  func update(reviews: [Review], needLoadMore: Bool) {
//    var items: [ReviewsViewModel.Item] = reviews.map { review -> ReviewsViewModel.Item in
//
//      let dateText: String?
//
//      if review.updateDate == nil {
//        dateText = review.publicationDate.toDate()
//      } else {
//        dateText = review.updateDate.toDate()
//      }
//
//      return .review(
//        ReviewCellViewModel(
//          id: review.id,
//          userNameText: nil,
//          dateText: dateText,
//          reviewText: review.comment,
//          rate: review.rating))
//    }
//
//    if needLoadMore {
//      items.append(.loading)
//    }
//
//    let viewModel = RatesViewModel(
//      state: .normal(items: items),
//      navigationTitle: localized("reviews").firstLetterUppercased())
//    viewController?.updateUI(viewModel: viewModel)
  }
}
