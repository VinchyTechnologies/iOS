//
//  WineViewContextMenuTappable.swift
//  Smart
//
//  Created by Михаил Исаченко on 02.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import FirebaseDynamicLinks
import VinchyAuthorization
import VinchyCore

// MARK: - ActionAfterLoginOrRegistration

enum ActionAfterLoginOrRegistration {
  case writeReview
  case none
}

// MARK: - WineViewContextMenuTappable

protocol WineViewContextMenuTappable: AnyObject {

  var dispatchGroup: DispatchGroup { get }
  var dispatchWorkItemHud: DispatchWorkItem { get }
  var contextMenuWine: Wine? { get set }
  var actionAfterAuthorization: ActionAfterLoginOrRegistration { get set }
  var router: WriteReviewRoutable & AuthorizationRoutable & ShowcaseRoutable & WineDetailRoutable & WriteNoteRoutable & ActivityRoutable { get }
  var presenter: ShowNetworkAlertPresentable { get }
  func didTapLeaveReviewContextMenu(wineID: Int64)
  func didTapWriteNoteContextMenu(wineID: Int64)
  func didTapShareContextMenu(wineID: Int64)
}

extension WineViewContextMenuTappable {

  // MARK: Internal

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

        let items = [contextMenuWine.title, url] as [Any]
        self?.router.presentActivityViewController(items: items)
      }
    }
  }

  // MARK: Private

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
//          DispatchQueue.main.async {
//            self.presenter.stopLoading()
//          }

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
