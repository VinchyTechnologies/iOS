//
//  ReviewsInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core

fileprivate enum C {
    static let limit = 20
}

final class ReviewsInteractor {
  
  private let router: ReviewsRouterProtocol
  private let presenter: ReviewsPresenterProtocol
  private let stateMachine = PagingStateMachine<[Any]>()
  private var reviews: [Any] = []
  
  init(
    router: ReviewsRouterProtocol,
    presenter: ReviewsPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
    configureStateMachine()
  }
  
  private func configureStateMachine() {
    stateMachine.observe { [weak self] (oldState, newState, _) in
      guard let self = self else { return }
      switch newState {
      case let .loaded(data):
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
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.stateMachine.invokeSuccess(with: Array(repeating: 1, count: 20))
    }
  }
  
  private func loadInitData() {
    stateMachine.load(offset: .zero)
  }
  
  private func loadMoreData() {
    stateMachine.load(offset: reviews.count)
  }
  
  private func handleLoadedData(_ data: [Any], oldState: PagingState<[Any]>) {
    reviews += data
    let needLoadMore: Bool
    switch oldState {
    case .error, .loaded, .initial:
        needLoadMore = false

    case .loading(let offset):
        needLoadMore = reviews.count == offset + C.limit
    }
    
    showData(needLoadMore: needLoadMore)
  }
  
  private func showData(error: Error? = nil, needLoadMore: Bool) {
    if let error = error {
      presenter.update(reviews: reviews, needLoadMore: needLoadMore)
      if reviews.isEmpty {
        print("show background error")
      } else {
        presenter.showErrorAlert(error: error)
      }
    } else {
      presenter.update(reviews: reviews, needLoadMore: needLoadMore)
    }
  }
}

// MARK: - ReviewsInteractorProtocol

extension ReviewsInteractor: ReviewsInteractorProtocol {
    
  func viewDidLoad() {
    presenter.startShimmer()
    loadInitData()
  }
  
  func willDisplayLoadingView() {
    loadMoreData()
  }
  
  func didSelectReview(id: Int64) {
    router.showBottomSheetReviewDetailViewController(reviewInput: .init(rate: 4.5, author: "aleksei_smirnov", date: "29.08.21", reviewText: "text"))
  }
}
