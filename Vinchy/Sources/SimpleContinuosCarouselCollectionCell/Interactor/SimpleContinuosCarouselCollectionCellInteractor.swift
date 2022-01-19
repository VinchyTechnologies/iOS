//
//  SimpleContinuosCarouselCollectionCellInteractor.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import FirebaseDynamicLinks
import VinchyCore
import VinchyUI
import WineDetail

// MARK: - SimpleContinuosCarouselCollectionCellInteractorDelegate

protocol SimpleContinuosCarouselCollectionCellInteractorDelegate: AnyObject {
  func didTapCompilationCell(input: ShowcaseInput)
  func didTapBottleCell(wineID: Int64)
}

// MARK: - SimpleContinuosCarouselCollectionCellInteractor

final class SimpleContinuosCarouselCollectionCellInteractor {

  // MARK: Lifecycle

  init(
    input: SimpleContinuosCarouselCollectionCellInput,
    router: SimpleContinuosCarouselCollectionCellRouterProtocol,
    presenter: SimpleContinuosCarouselCollectionCellPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Internal

  weak var delegate: SimpleContinuosCarouselCollectionCellInteractorDelegate?

  // MARK: Private

  private let input: SimpleContinuosCarouselCollectionCellInput
  private let dispatchGroup = DispatchGroup()
  private let router: SimpleContinuosCarouselCollectionCellRouterProtocol
  private let presenter: SimpleContinuosCarouselCollectionCellPresenterProtocol
  private var contextMenuWine: Wine?

  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }
  private var actionAfterAuthorization: ActionAfterLoginOrRegistration = .none

  private func openReviewFlow(wineID: Int64) {

//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//      self.dispatchWorkItemHud.perform()
//    }

    if UserDefaultsConfig.accountID != 0 {
      Reviews.shared.getReviews(
        wineID: wineID,
        accountID: UserDefaultsConfig.accountID,
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

// MARK: SimpleContinuosCarouselCollectionCellInteractorProtocol

extension SimpleContinuosCarouselCollectionCellInteractor: SimpleContinuosCarouselCollectionCellInteractorProtocol {
  func viewDidLoad() {
    guard let model = input.model else {
      return
    }
    presenter.update(model: model)
  }

  func didTapCompilationCell(wines: [ShortWine], title: String?) {
//    guard !wines.isEmpty else {
//      presenter.showAlertEmptyCollection()
//      return
//    }
//    delegate?.didTapCompilationCell(input: .init(title: title, mode: .normal(wines: wines)))
//    router.pushToShowcaseViewController(input: .init(title: title, mode: .normal(wines: wines)))
  }

  func didTapBottleCell(wineID: Int64) {
    delegate?.didTapBottleCell(wineID: wineID)
  }

  func didTapShareContextMenu(wineID: Int64) {
    dispatchGroup.enter()
    var error: Error?
    Wines.shared.getDetailWine(wineID: wineID) { [weak self]
      result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.contextMenuWine = response

      case .failure(let errorResponse):
        error = errorResponse
      }
      self.dispatchGroup.leave()
    }

    dispatchGroup.notify(queue: .main) {
      guard let contextMenuWine = self.contextMenuWine else {
        return
      }
      var components = URLComponents()
      components.scheme = Scheme.https.rawValue
      components.host = domain
      components.path = "/wines/" + String(contextMenuWine.id)

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
      shareLink.socialMetaTagParameters?.title = contextMenuWine.title
      shareLink.socialMetaTagParameters?.imageURL = contextMenuWine.mainImageUrl?.toURL

      shareLink.shorten { [weak self] url, _, error in
        if error != nil {
          return
        }

        guard let url = url else { return }

        let items: [Any] = [contextMenuWine.title, url]
        self?.router.presentActivityViewController(items: items)
      }
    }
  }

  func didTapLeaveReviewContextMenu(wineID: Int64) {
    openReviewFlow(wineID: wineID)
  }

  func didTapWriteNoteContextMenu(wineID: Int64) {
    dispatchGroup.enter()
    var error: Error?
    Wines.shared.getDetailWine(wineID: wineID) { [weak self]
      result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.contextMenuWine = response

      case .failure(let errorResponse):
        error = errorResponse
      }
      self.dispatchGroup.leave()
    }

    dispatchGroup.notify(queue: .main) {
      if let error = error {
        self.presenter.showNetworkErrorAlert(error: error)
      }

      guard let contextMenuWine = self.contextMenuWine else {
        return
      }

      if let note = notesRepository.findAll().first(where: { $0.wineID == wineID }) {
        self.router.pushToWriteViewController(note: note)
      } else {
        self.router.pushToWriteViewController(wine: contextMenuWine)
      }
    }
  }
}
