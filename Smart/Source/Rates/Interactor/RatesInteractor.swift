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

  // MARK: Internal

  var needLoadMore: Bool = true
  var numberDeletedReview = 0

  // MARK: Private

  private let authService = AuthService.shared
  private let input: RatesInput
  private let router: RatesRouterProtocol
  private let presenter: RatesPresenterProtocol
  private let stateMachine = PagingStateMachine<[ReviewedWine]>()
  private var reviews: [ReviewedWine] = []

  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }

  private func configureStateMachine() {
    stateMachine.observe { [weak self] oldState, newState, _ in
      guard let self = self else { return }
      switch newState {
      case .loaded(let data):
        self.handleLoadedData(data, oldState: oldState)

      case .loading(let offset, let usingRefreshControl):
        self.loadData(offset: offset, usingRefreshControl: usingRefreshControl)

      case .error(let error):
        self.showData(error: error, needLoadMore: false, wasUsedRefreshControl: false)

      case .initial:
        break
      }
    }
  }

  private func loadData(offset: Int, usingRefreshControl: Bool) {
    if let accountId = authService.currentUser?.accountID {
      if offset == .zero && !usingRefreshControl {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.dispatchWorkItemHud.perform()
        }
      }

      Wines.shared.getReviewedWines(accountId: accountId, offset: offset, limit: C.limit) { [weak self] result in
        switch result {
        case .success(let data):
          self?.stateMachine.invokeSuccess(with: data)

        case .failure(let error):
          self?.stateMachine.fail(with: error)
        }
      }
    } else {
      reviews.removeAll()
      presenter.showNeedsLoginError()
    }
  }

  private func loadInitData(usingRefreshControl: Bool) {
    stateMachine.load(offset: .zero, usingRefreshControl: usingRefreshControl)
  }

  private func loadMoreData(usingRefreshControl: Bool) {
    stateMachine.load(offset: reviews.count)
  }

  private func handleLoadedData(_ data: [ReviewedWine], oldState: PagingState<[ReviewedWine]>) {
    reviews += data
    var wasUsedRefreshControl: Bool = false
    let needLoadMore: Bool
    switch oldState {
    case .error, .loaded, .initial:
      needLoadMore = false

    case .loading(let offset, let usingRefreshControl):
      wasUsedRefreshControl = usingRefreshControl
      needLoadMore = reviews.count == offset + C.limit + numberDeletedReview //!data.isEmpty//reviews.count == offset + C.limit
      if offset == .zero {
        dispatchWorkItemHud.cancel()
        DispatchQueue.main.async {
          self.presenter.stopLoading()
        }
      }
    }

    self.needLoadMore = needLoadMore
    showData(needLoadMore: needLoadMore, wasUsedRefreshControl: wasUsedRefreshControl)
  }

  private func showData(error: Error? = nil, needLoadMore: Bool, wasUsedRefreshControl: Bool) {
    if let error = error {
      presenter.update(reviews: reviews, needLoadMore: needLoadMore, wasUsedRefreshControl: wasUsedRefreshControl)
      if reviews.isEmpty {
        presenter.showInitiallyLoadingError(error: error)
      } else {
        presenter.showErrorAlert(error: error)
      }
    } else {
      if reviews.isEmpty {
        presenter.showNoContentError()
      } else {
        presenter.update(reviews: reviews, needLoadMore: needLoadMore, wasUsedRefreshControl: wasUsedRefreshControl)
      }
    }
    dispatchWorkItemHud.cancel()
    DispatchQueue.main.async {
      self.presenter.stopLoading()
    }
  }
}

// MARK: RatesInteractorProtocol

extension RatesInteractor: RatesInteractorProtocol {
  
  func viewWillAppear() {
    if !authService.isAuthorized {
      reviews.removeAll()
      presenter.showNeedsLoginError()
    }
  }

  func didTapLoginButton() {
    router.presentAuthorizationViewController()
  }

  func didPullToRefresh() {
    reviews.removeAll()
    loadInitData(usingRefreshControl: true)
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
    Reviews.shared.deleteReview(reviewID: reviewID) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        self.reviews.removeAll(where: { $0.review?.id == reviewID })
        self.showData(needLoadMore: self.needLoadMore, wasUsedRefreshControl: false)

      case .failure(let error):
        self.showData(error: error, needLoadMore: self.needLoadMore, wasUsedRefreshControl: false)
      }
    }
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
    loadInitData(usingRefreshControl: false)
  }

  func willDisplayLoadingView() {
    loadMoreData(usingRefreshControl: false)
  }

  func didSelectReview(wineID: Int64) {
    router.pushToWineDetailViewController(wineID: wineID)
  }
}
