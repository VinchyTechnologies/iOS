//
//  RatesInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import FirebaseDynamicLinks
import VinchyAuthorization
import VinchyCore

// MARK: - C

private enum C {
  static let limit = 20
}

// MARK: - RatesInteractor

final class RatesInteractor {

  // MARK: Lifecycle

  init(
    input: RatesInput,
    router: RatesRouterProtocol,
    presenter: RatesPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
    configureStateMachine()
  }

  // MARK: Private

  private let authService = AuthService.shared
  private let input: RatesInput
  private let router: RatesRouterProtocol
  private let presenter: RatesPresenterProtocol
  private let stateMachine = PagingStateMachine<[ReviewedWine]>()
  private var reviews: [ReviewedWine] = []

  private func configureStateMachine() {
    stateMachine.observe { [weak self] oldState, newState, _ in
      guard let self = self else { return }
      switch newState {
      case .loaded(let data):
        self.handleLoadedData(data, oldState: oldState)

      case .loading(let offset):
        self.loadData(offset: offset)

      case .error(let error):
        self.showData(error: error, needLoadMore: false)

      case .initial:
        break
      }
    }
  }

  private func loadData(offset: Int) {
//    if let accountId = authService.currentUser?.accountID {
    Wines.shared.getReviewedWines(accountId: 78, offset: offset, limit: C.limit) { [weak self] result in
      switch result {
      case .success(let data):
        self?.stateMachine.invokeSuccess(with: data)

      case .failure(let error):
        self?.stateMachine.fail(with: error)
      }
    }
//    }
  }

  private func loadInitData() {
    stateMachine.load(offset: .zero)
  }

  private func loadMoreData() {
    stateMachine.load(offset: reviews.count)
  }

  private func handleLoadedData(_ data: [ReviewedWine], oldState: PagingState<[ReviewedWine]>) {
    reviews += data
    let needLoadMore: Bool
    switch oldState {
    case .error, .loaded, .initial:
      needLoadMore = false

    case .loading(let offset):
      needLoadMore = !data.isEmpty//reviews.count == offset + C.limit
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

// MARK: RatesInteractorProtocol

extension RatesInteractor: RatesInteractorProtocol {

  func didPullToRefresh() {

  }

  func didSwipeToShare(reviewID: Int, sourceView: UIView) {
    guard let wine = reviews.first(where: { $0.review?.id == reviewID })?.wine else { return }

    var components = URLComponents()
    components.scheme = Scheme.https.rawValue
    components.host = domain
    components.path = "/wines/" + String(wine.id)

    guard let linkParameter = components.url else {
      return
    }

    guard
      let shareLink = DynamicLinkComponents(
        link: linkParameter,
        domainURIPrefix: "https://vinchy.page.link")
    else {
      return
    }

    if let bundleID = Bundle.main.bundleIdentifier {
      shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
    }
    shareLink.iOSParameters?.appStoreID = "1536720416"
    shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
    shareLink.socialMetaTagParameters?.title = wine.title
    shareLink.socialMetaTagParameters?.imageURL = wine.mainImageUrl?.toURL

    shareLink.shorten { [weak self] url, _, error in
      if error != nil {
        return
      }

      guard let url = url else { return }

      let items = [wine.title, url] as [Any]
      self?.router.presentActivityViewController(items: items, sourceView: sourceView)
    }
  }

  func didSwipeToEdit(reviewID: Int) {
    guard
      let review = reviews.first(where: { $0.review?.id == reviewID }),
      let wineID = review.wine?.id
    else {
      return
    }

    router.presentWriteReviewViewController(
      reviewID: review.review?.id,
      wineID: wineID,
      rating: review.review?.rating ?? 0,
      reviewText: review.review?.comment)
  }

  func didSwipeToDelete(reviewID: Int) {
    Reviews.shared
  }

  func didTapMore(reviewID: Int) {
    guard
      let reviewedWine = reviews.first(where: { $0.review?.id == reviewID }),
      let review = reviewedWine.review
    else {
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

  func viewDidLoad() {
    presenter.startShimmer()
    loadInitData()
  }

  func willDisplayLoadingView() {
    loadMoreData()
  }

  func didSelectReview(wineID: Int64) {
    router.pushToWineDetailViewController(wineID: wineID)
  }
}
