//
//  WriteReviewInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore
import Core

final class WriteReviewInteractor {
  
  private let input: WriteReviewInput
  private let router: WriteReviewRouterProtocol
  private let presenter: WriteReviewPresenterProtocol
  
  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }
  
  init(
    input: WriteReviewInput,
    router: WriteReviewRouterProtocol,
    presenter: WriteReviewPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }
}

// MARK: - WriteReviewInteractorProtocol

extension WriteReviewInteractor: WriteReviewInteractorProtocol {
  
  func viewDidLoad() {
    presenter.setPlaceholder()
    if let rating = input.rating {
      presenter.update(rating: rating, comment: input.comment)
    }
  }
  
  func didTapSend(rating: Double, comment: String?) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.dispatchWorkItemHud.perform()
    }
    
    if input.rating == rating && input.comment == comment {
      router.dismiss(completion: nil)
      return
    }

    let accountID = UserDefaultsConfig.accountID
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
            self.router.presentAuthorizationViewController()
          } else {
            self.presenter.showAlertErrorWhileCreatingReview(error: error)
          }
        }
      }
    }
  }
}
