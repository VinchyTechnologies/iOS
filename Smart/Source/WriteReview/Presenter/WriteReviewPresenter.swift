//
//  WriteReviewPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import StringFormatting

final class WriteReviewPresenter {
    
  let input: WriteReviewInput
  weak var viewController: WriteReviewViewControllerProtocol?
  
  init(input: WriteReviewInput, viewController: WriteReviewViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - WriteReviewPresenterProtocol

extension WriteReviewPresenter: WriteReviewPresenterProtocol {
  
  func startLoading() {
    viewController?.startLoadingAnimation()
    viewController?.addLoader()
  }
  
  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }
  
  func showAlertErrorWhileCreatingReview(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }
  
  func showAlertErrorWhileUpdatingReview(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }
  
  var statusAlertViewModelAfterCreate: StatusAlertViewModel {
    .init(
      image: UIImage(systemName: "star.fill"),
      titleText: localized("did_send_rating").firstLetterUppercased(),
      descriptionText: nil)
  }
  
  var statusAlertViewModelAfterUpdate: StatusAlertViewModel {
    .init(
      image: UIImage(systemName: "star.fill"),
      titleText: localized("did_update_rating").firstLetterUppercased(),
      descriptionText: nil)
  }
  
  func update(rating: Double, comment: String?) {
    let navigationTitle = input.reviewID == nil
      ? localized("write_review").firstLetterUppercased()
      : localized("update_review").firstLetterUppercased()
    let rightBarButtonText = localized("send").firstLetterUppercased()
    let underStarText = localized("tap_a_star_to_rate").firstLetterUppercased()
    viewController?.updateUI(viewModel: .init(rating: rating, reviewText: comment, navigationTitle: navigationTitle, rightBarButtonText: rightBarButtonText, underStarText: underStarText))
  }
  
  func setPlaceholder() {
    viewController?.setPlaceholder(placeholder: localized("review_placeholder"))
  }
}
