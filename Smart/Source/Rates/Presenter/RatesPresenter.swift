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
      titleText: localized("Пока пусто").firstLetterUppercased(),
      subtitleText: "Вы не оценили ни одного вина :(",
      buttonText: nil)
    viewController?.updateUI(
      viewModel: .init(
        state: .noContent(errorViewModel: errorModel),
        navigationTitle: localized("reviews").firstLetterUppercased()))
  }

  func showNeedsLoginError() {
    let errorModel = ErrorViewModel(
      titleText: localized("Здесь будут ваши оценки").firstLetterUppercased(),
      subtitleText: "Для этого необходимо авторизоваться",
      buttonText: localized("login").firstLetterUppercased())
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
            starValue: wine.rating))
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
