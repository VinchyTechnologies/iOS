//
//  ReviewsInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import VinchyCore

// MARK: - C

private enum C {
  static let limit = 20
}

// MARK: - ReviewsInteractor

final class ReviewsInteractor {

  // MARK: Lifecycle

  init(
    input: ReviewsInput,
    router: ReviewsRouterProtocol,
    presenter: ReviewsPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
    configureStateMachine()
  }

  // MARK: Private

  private let input: ReviewsInput
  private let router: ReviewsRouterProtocol
  private let presenter: ReviewsPresenterProtocol
  private let stateMachine = PagingStateMachine<[Review]>()
  private var reviews: [Review] = []

  private func configureStateMachine() {
    stateMachine.observe { [weak self] oldState, newState, _ in
      guard let self = self else { return }
      switch newState {
      case .loaded(let data):
        self.handleLoadedData(data, oldState: oldState)

      case .loading(let offset, _):
        self.loadData(offset: offset)

      case .error(let error):
        self.showData(error: error, needLoadMore: false)

      case .initial:
        break
      }
    }
  }

  private func loadData(offset: Int) {
    Reviews.shared.getReviews(
      wineID: input.wineID,
      accountID: nil,
      offset: offset,
      limit: C.limit) { [weak self] result in
        switch result {
        case .success(let data):
          self?.stateMachine.invokeSuccess(with: data)

        case .failure(let error):
          self?.stateMachine.fail(with: error)
        }
    }
  }

  private func loadInitData() {
    stateMachine.load(offset: .zero)
  }

  private func loadMoreData() {
    stateMachine.load(offset: reviews.count)
  }

  private func handleLoadedData(_ data: [Review], oldState: PagingState<[Review]>) {
    reviews += data
    let needLoadMore: Bool
    switch oldState {
    case .error, .loaded, .initial:
      needLoadMore = false

    case .loading(let offset, _):
      needLoadMore = reviews.count == offset + C.limit
    }

    showData(needLoadMore: needLoadMore)
  }

  private func showData(error: Error? = nil, needLoadMore: Bool) {
    if let error = error {
      presenter.update(reviews: reviews, needLoadMore: needLoadMore)
      if reviews.isEmpty {
        presenter.showInitiallyLoadingError(error: error)
      } else {
        presenter.showErrorAlert(error: error)
      }
    } else {
      presenter.update(reviews: reviews, needLoadMore: needLoadMore)
    }
  }
}

// MARK: ReviewsInteractorProtocol

extension ReviewsInteractor: ReviewsInteractorProtocol {
  func viewDidLoad() {
    presenter.startShimmer()
    loadInitData()
  }

  func willDisplayLoadingView() {
    loadMoreData()
  }

  func didSelectReview(id: Int) {
    guard let review = reviews.first(where: { $0.id == id }) else {
      return
    }

    let dateText: String?

    if review.updateDate == nil {
      dateText = review.publicationDate.toDate()
    } else {
      dateText = review.updateDate.toDate()
    }

    router.showBottomSheetReviewDetailViewController(reviewInput:
      .init(
        rate: review.rating,
        author: nil, // TODO: - Author
        date: dateText,
        reviewText: review.comment))
  }
}
