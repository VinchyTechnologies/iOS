//
//  WineDetailInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import UIKit.UIButton
import UIKit.UIView
import VinchyCore
import VinchyUI

// MARK: - WineDetailMoreActions

public enum WineDetailMoreActions {
  case reportAnError
  case dislike
}

// MARK: - ActionAfterLoginOrRegistration

public enum ActionAfterLoginOrRegistration { // TODO: - move to auth
  case writeReview
  case none
}

// MARK: - WineDetailInteractor

final class WineDetailInteractor {

  // MARK: Lifecycle

  init(
    input: WineDetailInput,
    router: WineDetailRouterProtocol,
    presenter: WineDetailPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: WineDetailRouterProtocol
  private let presenter: WineDetailPresenterProtocol
  private let input: WineDetailInput
  private var isGeneralInfoCollapsed: Bool = true
  private let dispatchGroup = DispatchGroup()
  private let authService = AuthService.shared

  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }

  private var rating: Rating?
  private let dataBase = winesRepository

  private var wine: Wine?
  private var reviews: [Review]?
  private var stores: [PartnerInfo]?
  private var actionAfterAuthorization: ActionAfterLoginOrRegistration = .none

  private func loadWineInfo() {

    var error: Error?

    if wine == nil {
      dispatchGroup.enter()
      Wines.shared.getDetailWine(wineID: input.wineID) { [weak self]
        result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
          self.wine = response

        case .failure(let errorResponse):
          error = errorResponse
        }
        self.dispatchGroup.leave()
      }
    }

    if reviews == nil {
      dispatchGroup.enter()
      Reviews.shared.getReviews(wineID: input.wineID, accountID: nil, offset: 0, limit: 5) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
          self.reviews = response

        case .failure:
          self.reviews = nil
        }
        self.dispatchGroup.leave()
      }

      dispatchGroup.enter()
      Reviews.shared.getRating(wineID: input.wineID) { [weak self] result in
        switch result {
        case .success(let response):
          self?.rating = response

        case .failure:
          break
        }
        self?.dispatchGroup.leave()
      }
    }

    if stores == nil {
      dispatchGroup.enter()
      Partners.shared.getPartnersByWine(wineID: input.wineID, latitude: 55.755786, longitude: 37.617633, limit: 5, offset: 0) { [weak self] result in // TODO: - user location
        guard let self = self else { return }
        switch result {
        case .success(let response):
          self.stores = response

        case .failure:
          break
        }
        self.dispatchGroup.leave()
      }
    }

    dispatchGroup.notify(queue: .main) {
      self.dispatchWorkItemHud.cancel()

      if let wine = self.wine {
        Task {
          await self.presenter.update(
            wine: wine,
            reviews: self.reviews,
            isLiked: self.isFavourite(wine: wine),
            isDisliked: self.isDisliked(wine: wine),
            rating: self.rating,
            currency: UserDefaultsConfig.currency,
            stores: self.stores,
            isGeneralInfoCollapsed: self.isGeneralInfoCollapsed)
        }
      }

      if let error = error {
        self.presenter.showNetworkErrorAlert(error: error)
      }

      DispatchQueue.main.async {
        self.presenter.stopLoading()
      }
    }
  }

  private func isFavourite(wine: Wine) -> Bool {
    winesRepository.findAll().first(where: { $0.wineID == wine.id })?.isLiked == true
  }

  private func isDisliked(wine: Wine) -> Bool {
    winesRepository.findAll().first(where: { $0.wineID == wine.id })?.isDisliked == true
  }

  private func openReviewFlow() {
    guard let wineID = wine?.id else {
      return
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.dispatchWorkItemHud.perform()
    }

    if authService.isAuthorized {
      Reviews.shared.getReviews(
        wineID: wineID,
        accountID: authService.currentUser?.accountID,
        offset: 0,
        limit: 1) { [weak self] result in

          guard let self = self else { return }

          self.dispatchWorkItemHud.cancel()
          DispatchQueue.main.async {
            self.presenter.stopLoading()
          }

          switch result {
          case .success(let model):
            guard let review = model.first else {
              self.router.presentWriteReviewViewController(reviewID: nil, wineID: wineID, rating: 0, reviewText: nil)
              return
            }
            self.router.presentWriteReviewViewController(
              reviewID: review.id,
              wineID: wineID,
              rating: review.rating,
              reviewText: review.comment)

          case .failure:
            self.router.presentWriteReviewViewController(reviewID: nil, wineID: wineID, rating: 0, reviewText: nil)
          }
      }
    } else {
      actionAfterAuthorization = .writeReview
      router.presentAuthorizationViewController()
    }
  }
}

// MARK: WineDetailInteractorProtocol

extension WineDetailInteractor: WineDetailInteractorProtocol {
  var contextMenuRouter: ActivityRoutable & WriteNoteRoutable {
    router
  }

  func didTapWinery() {
    guard let wine = wine else {
      return
    }
    guard let wineryId = wine.winery?.id else {
      return
    }
    if !input.isAppClip {
      router.pushToShowcaseViewController(input: .init(title: wine.winery?.title, mode: .advancedSearch(params: [("wineries_ids", String(wineryId))])))
    }
  }

  func requestShowStatusAlert(viewModel: StatusAlertViewModel) {
    router.showStatusAlert(viewModel: viewModel)
  }

  func didTapShareContextMenu(wineID: Int64, sourceView: UIView) {
    Wines.shared.getDetailWine(wineID: wineID) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.router.didTapShare(type: .fullInfo(wineID: wineID, titleText: response.title, bottleURL: response.mainImageUrl?.toURL, sourceView: sourceView))

      case .failure(let errorResponse):
        print(errorResponse)
      }
    }
  }

  func didTapWriteNoteContextMenu(wineID: Int64) {
    Wines.shared.getDetailWine(wineID: wineID) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        let contextMenuWine = response
        if let note = notesRepository.findAll().first(where: { $0.wineID == wineID }) {
          self.contextMenuRouter.pushToWriteViewController(note: note)
        } else {
          self.contextMenuRouter.pushToWriteViewController(wine: contextMenuWine)
        }

      case .failure(let errorResponse):
        print(errorResponse)
      }
    }
  }

  func didSelectWine(wineID: Int64) {
    router.pushToWineDetailViewController(wineID: wineID)
  }

  func didTapSeeAllStores() {
    router.pushToStoresViewController(wineID: input.wineID)
  }

  func didSelectStore(affilatedId: Int) {
    router.pushToStoreViewController(affilatedId: affilatedId)
  }

  func didShowTutorial() {
    UserDefaultsConfig.userHasSeenTutorialForReviewButton = true
  }

  func didScrollStopped() {
    if !UserDefaultsConfig.userHasSeenTutorialForReviewButton && !input.isAppClip {
      presenter.showReviewButtonTutorial()
    }
  }

  func didTapExpandOrCollapseGeneralInfo() async {
    guard let wine = wine else {
      return
    }
    isGeneralInfoCollapsed = !isGeneralInfoCollapsed
    await presenter.expandOrCollapseGeneralInfo(wine: wine, isGeneralInfoCollapsed: isGeneralInfoCollapsed)
  }

  func didTapStarsRatingControl() {
    if !input.isAppClip {
      openReviewFlow()
    }
  }

  func didSuccessfullyLoginOrRegister() {
    switch actionAfterAuthorization {
    case .writeReview:
      didTapWriteReviewButton()

    case .none:
      break
    }
  }

  func didTapReview(reviewID: Int) {
    guard
      let review = reviews?.first(where: { $0.id == reviewID })
    else {
      return
    }

    let dateText: String?
    if review.updateDate == nil {
      dateText = review.publicationDate.toDate()
    } else {
      dateText = review.updateDate.toDate()
    }

    router.showBottomSheetReviewDetailViewController(reviewInput: .init(rate: review.rating, author: nil, date: dateText, reviewText: review.comment))
  }

  func didTapSeeAllReviews() {
    guard let wineID = wine?.id else {
      return
    }
    router.pushToReviewsViewController(wineID: wineID)
  }

  func didTapWriteReviewButton() {
    if input.isAppClip {
      presenter.showAppClipDownloadFullApp()
    } else {
      openReviewFlow()
    }
  }

  func didTapMore(_ button: UIButton) {
    router.showMoreActionSheet(
      reportAnErrorText: presenter.reportAnErrorText,
      button: button)
  }

  func didTapPriceButton() {
    if !(stores?.isEmpty == true) {
      presenter.scrollToWhereToBuySections()
    }
  }

  func didTapReportAnError(sourceView: UIView) {
    guard let wine = wine, let to = presenter.reportAnErrorRecipients.first else { return }
    router.presentContactActionSheet(to: to, subject: "", body: wine.title, includingThirdPartyApps: false, sourceView: sourceView)
  }

  func didTapDislikeButton() {
    guard let wine = wine else { return }

    if isFavourite(wine: wine) {
      presenter.showAlertWineAlreadyLiked()
      return
    }

    if let dbWine = winesRepository.findAll().filter({ $0.isDisliked == true }).first(where: { $0.wineID == wine.id }) {
      dataBase.remove(dbWine)
    } else {
      let maxId = winesRepository.findAll().map { $0.id }.max() ?? 0
      let id = maxId + 1
      winesRepository.append(VWine(id: id, wineID: wine.id, title: wine.title, isLiked: false, isDisliked: true))
      presenter.showStatusAlertDidDislikedSuccessfully()
    }
  }

  func didTapShareButton(_ button: UIButton) {
    guard let wine = wine else { return }
    router.didTapShare(
      type: .fullInfo(
        wineID: wine.id,
        titleText: wine.title,
        bottleURL: wine.mainImageUrl?.toURL,
        sourceView: button))
  }

  func viewDidLoad() {
    loadWineInfo()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.dispatchWorkItemHud.perform()
    }
  }

  func didTapNotes() {
    guard let wine = wine else { return }
    if let note = notesRepository.findAll().first(where: { $0.wineID == wine.id }) {
      router.pushToWriteViewController(note: note)
    } else {
      router.pushToWriteViewController(wine: wine)
    }
  }

  func didTapLikeButton(_ button: UIButton) {

    guard let wine = wine else { return }

    if isDisliked(wine: wine) {
      button.isSelected = !button.isSelected
      presenter.showAlertWineAlreadyDisliked()
      return
    }

    if let dbWine = winesRepository.findAll().filter({ $0.isLiked == true }).first(where: { $0.wineID == wine.id }) {
      dataBase.remove(dbWine)
//      trackEvent("wine_detail_did_tap_like_button", params: ["isInitiallyLiked": true])
      presenter.setLikedStatus(isLiked: false)
    } else {
      let maxId = winesRepository.findAll().map { $0.id }.max() ?? 0
      let id = maxId + 1
      winesRepository.append(VWine(id: id, wineID: wine.id, title: wine.title, isLiked: true, isDisliked: false))
      presenter.setLikedStatus(isLiked: true)
      presenter.showStatusAlertDidLikedSuccessfully()
//      trackEvent("wine_detail_did_tap_like_button", params: ["isInitiallyLiked": false])
    }
  }

  func didTapSimilarWine(wineID: Int64) {
    router.pushToWineDetailViewController(wineID: wineID)
  }
}
