//
//  WineViewContextMenuTappable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import FirebaseDynamicLinks
import VinchyCore

// MARK: - WineViewContextMenuTappable

public protocol WineViewContextMenuTappable: AnyObject {
  var contextMenuRouter: ActivityRoutable & WriteNoteRoutable { get }
  func didTapShareContextMenu(wineID: Int64, sourceView: UIView)
  func didTapWriteNoteContextMenu(wineID: Int64)
}

extension WineViewContextMenuTappable {
  public func didTapWriteNoteContextMenu(wineID: Int64) {
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

  public func didTapShareContextMenu(wineID: Int64, sourceView: UIView) {
    Wines.shared.getDetailWine(wineID: wineID) { [weak self] result in
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

          let items = [contextMenuWine.title, url] as [Any]
          self?.contextMenuRouter.presentActivityViewController(items: items, sourceView: sourceView)
        }

      case .failure(let errorResponse):
        print(errorResponse)
      }
    }
  }
}
