//
//  WriteReviewInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import VinchyAuthorization
import VinchyCore

// MARK: - WriteReviewInteractor

final class WriteReviewInteractor {

  // MARK: Lifecycle

  init(
    input: WriteReviewInput,
    router: WriteReviewRouterProtocol,
    presenter: WriteReviewPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let input: WriteReviewInput
  private let router: WriteReviewRouterProtocol
  private let presenter: WriteReviewPresenterProtocol
  private let authService = AuthService.shared

  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }
}

// MARK: WriteReviewInteractorProtocol

extension WriteReviewInteractor: WriteReviewInteractorProtocol {
  func viewDidLoad() {
    presenter.setPlaceholder()
    if let rating = input.rating {
      presenter.update(rating: rating, comment: input.comment)
    }
  }

  func didChangeContent(comment: String?, rating: Double?) {
    if rating == 0 || rating == nil {
      presenter.setSendButtonEnabled(false)
      return
    }

    let flag = !(input.rating == rating && input.comment == comment)
    presenter.setSendButtonEnabled(flag)
  }

  func didTapSend(rating: Double, comment: String?) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.dispatchWorkItemHud.perform()
    }

    if input.rating == rating, input.comment == comment {
      dispatchWorkItemHud.cancel()
      presenter.stopLoading()
      router.dismiss(completion: nil)
      return
    }

    if rating == 0 {
      dispatchWorkItemHud.cancel()
      presenter.stopLoading()
      presenter.showAlertZeroRating()
      return
    }

    let accountID = authService.currentUser?.accountID ?? 0
    let comment = comment == "" ? nil : comment

    if let reviewID = input.reviewID {
      Reviews.shared.updateReview(reviewID: reviewID, rating: rating, comment: comment) { [weak self] result in
        guard let self = self else { return }
        self.dispatchWorkItemHud.cancel()
        DispatchQueue.main.async {
          self.presenter.stopLoading()
        }
        switch result {
        case .success:
          self.router.dismissAfterUpdate(statusAlertViewModel: self.presenter.statusAlertViewModelAfterUpdate)

        case .failure(let error):
          if case APIError.updateTokensErrorShouldShowAuthScreen = error {
            ratesRepository.state = .needsReload
            self.router.presentAuthorizationViewController()
          } else {
            self.presenter.showAlertErrorWhileUpdatingReview(error: error)
          }
        }
      }
    } else {
      Reviews.shared.createReview(
        wineID: input.wineID,
        accountID: accountID,
        rating: rating,
        comment: comment) { [weak self] result in
          guard let self = self else { return }
          self.dispatchWorkItemHud.cancel()
          DispatchQueue.main.async {
            self.presenter.stopLoading()
          }
          switch result {
          case .success:
            self.router.dismissAfterCreate(statusAlertViewModel: self.presenter.statusAlertViewModelAfterCreate)

          case .failure(let error):
            if case APIError.updateTokensErrorShouldShowAuthScreen = error {
              ratesRepository.state = .needsReload
              self.router.presentAuthorizationViewController()
            } else {
              self.presenter.showAlertErrorWhileCreatingReview(error: error)
            }
          }
      }
    }
  }
}
