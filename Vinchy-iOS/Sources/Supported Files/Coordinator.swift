//
//  Coordinator.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import AdvancedSearch
import Core
import Database
import DisplayMini
import FirebaseDynamicLinks
import FittedSheets
import Network
import Questions
import UIKit
import VinchyAuthorization
import VinchyCart
import VinchyCore
import VinchyUI

// MARK: - Coordinator

final class Coordinator: ShowcaseRoutable, WineDetailRoutable, WriteNoteRoutable, ActivityRoutable, AdvancedSearchRoutable, ReviewDetailRoutable, ReviewsRoutable, WriteReviewRoutable, StoresRoutable, StoreRoutable, ResultsSearchRoutable, AuthorizationRoutable, WineShareRoutable, StatusAlertable, SafariRoutable, StoreShareRoutable, CollectionShareRoutable, CartRoutable, QuestionsRoutable, QRRoutable {
  static let shared = Coordinator()

  func presentQRViewController(affilatedId: Int, wineID: Int64) {
    let controller = QRAssembly.assemblyModule(input: .init(affilietedId: affilatedId, wineID: wineID))
    let navigationController = VinchyNavigationController(rootViewController: controller)
    UIApplication.topViewController()?.present(navigationController, animated: true, completion: nil)
  }

  func presentQuestiosViewController(affilatedId: Int, questions: [Question], currencyCode: String, questionsNavigationControllerDelegate: QuestionsNavigationControllerDelegate?) {
    let controller = QuestionsNavigationController(questions: questions, affilatedId: affilatedId, currencyCode: currencyCode, coordinator: Coordinator.shared)
    controller.questionsNavigationControllerDelegate = questionsNavigationControllerDelegate
    if UIDevice.current.userInterfaceIdiom == .pad {
      controller.modalPresentationStyle = .fullScreen
    }
    UIApplication.topViewController()?.present(controller, animated: true, completion: nil)
  }

  func presentCartViewController(affilatedId: Int) {
    let controller = CartAssembly.assemblyModule(input: .init(affilatedId: affilatedId), coordinator: Coordinator.shared)
    let navigationController = VinchyNavigationController(rootViewController: controller)
    UIApplication.topViewController()?.present(navigationController, animated: true, completion: nil)
  }

  func didTapShareCollection(type: CollectionShareType) {
    switch type {
    case .fullInfo(let collectionID, let titleText, let logoURL, let sourceView):
      var components = URLComponents()
      components.scheme = Scheme.https.rawValue
      components.host = domain
      components.path = "/list/" + String(collectionID)

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
      shareLink.socialMetaTagParameters?.title = titleText
      shareLink.socialMetaTagParameters?.imageURL = logoURL

      shareLink.shorten { [weak self] url, _, error in
        if error != nil {
          return
        }

        guard let url = url else { return }

        let items: [Any] = [titleText as Any, url]
        self?.presentActivityViewController(items: items, sourceView: sourceView)
      }
    }
  }

  func didTapShareStore(type: StoreShareType) {
    switch type {
    case .fullInfo(let affilatedId, let titleText, let logoURL, let sourceView):
      var components = URLComponents()
      components.scheme = Scheme.https.rawValue
      components.host = domain
      components.path = "/store/" + String(affilatedId)

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
      shareLink.socialMetaTagParameters?.title = titleText
      shareLink.socialMetaTagParameters?.imageURL = logoURL

      shareLink.shorten { [weak self] url, _, error in
        if error != nil {
          return
        }

        guard let url = url else { return }

        let items: [Any] = [titleText as Any, url]
        self?.presentActivityViewController(items: items, sourceView: sourceView)
      }
    }
  }

  func didTapShare(type: WineShareType) {
    switch type {
    case .fullInfo(let wineID, let titleText, let bottleURL, let sourceView):
      var components = URLComponents()
      components.scheme = Scheme.https.rawValue
      components.host = domain
      components.path = "/wines/" + String(wineID)

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
      shareLink.socialMetaTagParameters?.title = titleText
      shareLink.socialMetaTagParameters?.imageURL = bottleURL

      shareLink.shorten { [weak self] url, _, error in
        if error != nil {
          return
        }

        guard let url = url else { return }

        let items: [Any] = [titleText as Any, url]
        self?.presentActivityViewController(items: items, sourceView: sourceView)
      }
    }
  }

  func presentAdvancedSearch(preselectedFilters: [(String, String)], isPriceFilterAvailable: Bool, currencyCode: String?, affiliedId: Int, delegate: AdvancedSearchOutputDelegate?) {
    let controller = FiltersAssembly.assemblyModule(input: .init(preselectedFilters: preselectedFilters, isPriceFilterAvailable: isPriceFilterAvailable, currencyCode: currencyCode, affiliedId: affiliedId))
    let navController = AdvancedSearchNavigationController(rootViewController: controller)
    navController.advancedSearchOutputDelegate = delegate
    UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
  }

  func pushToShowcaseViewController(input: ShowcaseInput) {
    let controller = ShowcaseAssembly.assemblyModule(input: input)
    controller.hidesBottomBarWhenPushed = true
    UIApplication.topViewController()?.navigationController?.pushViewController(
      controller,
      animated: true)
  }
}

extension AuthorizationRoutable {
  public func presentAuthorizationViewController() {
    let controller: AuthorizationNavigationController = ChooseAuthTypeAssembly.assemblyModule()
    controller.authOutputDelegate = UIApplication.topViewController() as? AuthorizationOutputDelegate
    let options = SheetOptions(shrinkPresentingViewController: false)
    let sheetController = SheetViewController(
      controller: controller,
      sizes: [.fixed(350)],
      options: options)
    UIApplication.topViewController()?.present(sheetController, animated: true, completion: nil)
  }
}

extension WineViewContextMenuTappable {
  public func didTapWriteNoteContextMenu(wineID: Int64) {
    Wines.shared.getDetailWine(wineID: wineID, currencyCode: UserDefaultsConfig.currency) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        let contextMenuWine = response
        if let note = notesRepository.findAll().first(where: { $0.wineID == wineID }) {
          self.contextMenuRouter.presentWriteViewController(note: note)
        } else {
          self.contextMenuRouter.presentWriteViewController(wine: contextMenuWine)
        }

      case .failure(let errorResponse):
        print(errorResponse)
      }
    }
  }

  public func didTapShareContextMenu(wineID: Int64, sourceView: UIView) {
    Wines.shared.getDetailWine(wineID: wineID, currencyCode: UserDefaultsConfig.currency) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        let contextMenuWine = response
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
          self?.contextMenuRouter.presentActivityViewController(items: items, sourceView: sourceView)
        }

      case .failure(let errorResponse):
        print(errorResponse)
      }
    }
  }
}
