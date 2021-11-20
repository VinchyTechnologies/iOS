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

}

// MARK: RatesPresenterProtocol

extension RatesPresenter: RatesPresenterProtocol {

  func showNoContentError() {
    let errorModel = ErrorViewModel(
      titleText: localized("nothing_here").firstLetterUppercased(),
      subtitleText: localized("you_have_not_rated_any_wine").firstLetterUppercased(),
      buttonText: nil)
    viewController?.updateUI(
      viewModel: .init(
        state: .noContent(errorViewModel: errorModel),
        navigationTitle: localized("reviews").firstLetterUppercased()))
  }

  func showNeedsLoginError() {
    let errorModel = ErrorViewModel(
      titleText: localized("your_rated_wines_will_be_here").firstLetterUppercased(),
      subtitleText: localized("you_need_to_login_first").firstLetterUppercased(),
      buttonText: localized("sign_in_or_register").firstLetterUppercased())
    viewController?.updateUI(
      viewModel: .init(
        state: .noLogin(errorViewModel: errorModel),
        navigationTitle: localized("reviews").firstLetterUppercased()))
  }

  func showInitiallyLoadingError(error: Error) {
    let errorModel = ErrorViewModel(
      titleText: localized("error").firstLetterUppercased(),
      subtitleText: error.localizedDescription,
      buttonText: localized("reload").firstLetterUppercased())
    viewController?.updateUI(
      viewModel: .init(
        state: .error(errorViewModel: errorModel),
        navigationTitle: localized("reviews").firstLetterUppercased()))
  }

  func showErrorAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }

  func startLoading() {
    viewController?.startLoadingAnimation()
    viewController?.addLoader()
  }

  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }

  func update(reviews: [ReviewedWine], needLoadMore: Bool, wasUsedRefreshControl: Bool) {
    var items: [RatesViewModel.Item] = reviews.compactMap { reviewedWine -> RatesViewModel.Item? in
      if
        let review = reviewedWine.review,
        let wine = reviewedWine.wine
      {
        return .review(
          WineRateView.Content.init(
            wineID: wine.id,
            reviewID: review.id,
            bottleURL: wine.mainImageUrl,
            titleText: wine.title,
            reviewText: review.comment,
            readMoreText: localized("more").firstLetterUppercased(),
            wineryText: wine.winery?.title,
            starValue: review.rating))
      }
      return nil
    }

    if needLoadMore {
      items.append(.loading)
    }

    let viewModel = RatesViewModel(
      state: .normal(items: items),
      navigationTitle: localized("reviews").firstLetterUppercased())
    viewController?.updateUI(viewModel: viewModel)
//    if wasUsedRefreshControl {
    viewController?.stopPullRefreshing()
//    }
  }
}
