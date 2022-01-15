//
//  StoreRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreLocation
import Database
import DisplayMini
import StringFormatting
import UIKit
import VinchyCore
import VinchyUI

// MARK: - StoreRouter

final class StoreRouter {

  // MARK: Lifecycle

  init(
    input: StoreInput,
    viewController: UIViewController,
    coordinator: StoreAssembly.Coordinator)
  {
    self.input = input
    self.viewController = viewController
    self.coordinator = coordinator
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: StoreInteractorProtocol?

  // MARK: Private

  private let coordinator: StoreAssembly.Coordinator

  private let input: StoreInput

}

// MARK: StoreRouterProtocol

extension StoreRouter: StoreRouterProtocol {

  func didTapShareStore(type: StoreShareType) {
    coordinator.didTapShareStore(type: type)
  }

  func presentSafari(url: URL) {
    coordinator.presentSafari(url: url)
  }

  func didTapShare(type: WineShareType) {
    coordinator.didTapShare(type: type)
  }

  func pushToResultsSearchController(affilatedId: Int, resultsSearchDelegate: ResultsSearchDelegate?) {
    coordinator.pushToResultsSearchController(
      affilatedId: affilatedId,
      resultsSearchDelegate: resultsSearchDelegate)
  }

  func presentActivityViewController(items: [Any], sourceView: UIView) {
    coordinator.presentActivityViewController(items: items, sourceView: sourceView)
  }

  func presentWriteViewController(note: VNote) {
    coordinator.presentWriteViewController(note: note)
  }

  func presentWriteViewController(wine: Wine) {
    coordinator.presentWriteViewController(wine: wine)
  }

  func pushToWineDetailViewController(wineID: Int64) {
    coordinator.pushToWineDetailViewController(wineID: wineID)
  }

  func presentWineDetailViewController(wineID: Int64) {
    coordinator.presentWineDetailViewController(wineID: wineID)
  }

  func presentFilter(preselectedFilters: [(String, String)]) {
    coordinator.presentAdvancedSearch(
      input: .init(mode: .asView(preselectedFilters: preselectedFilters)),
      delegate: interactor)
  }

  func showRoutesActionSheet(
    storeTitleText: String?,
    coordinate: CLLocationCoordinate2D,
    button: UIButton)
  {
    let alert = UIAlertController(title: localized("build_route").firstLetterUppercased(), message: nil, preferredStyle: .actionSheet)

    if let appleURLString = "http://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)&q=\(storeTitleText ?? "")&z=15".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let appleURL = URL(string: appleURLString), UIApplication.shared.canOpenURL(appleURL) {
      alert.addAction(UIAlertAction(title: localized("apple_maps").firstLetterUppercased(), style: .default, handler: { [weak self] _ in
        self?.open(urlString: appleURLString, errorCompletion: {})
      }))
    }

    if let yandexURLString = "yandexmaps://maps.yandex.ru/?pt=\(coordinate.longitude),\(coordinate.latitude)&z=18&l=map&text=\(storeTitleText ?? "")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let yandexURL = URL(string: yandexURLString), UIApplication.shared.canOpenURL(yandexURL) {
      alert.addAction(UIAlertAction(title: localized("yandex_maps").firstLetterUppercased(), style: .default, handler: { [weak self] _ in
        self?.open(urlString: yandexURLString, errorCompletion: {})
      }))
    }

    if let googleURLString = "comgooglemaps://?q=\(storeTitleText ?? "")&center=\(coordinate.longitude),\(coordinate.latitude)&zoom=15".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let googleURL = URL(string: googleURLString), UIApplication.shared.canOpenURL(googleURL) {
      alert.addAction(UIAlertAction(title: localized("google_maps").firstLetterUppercased(), style: .default, handler: { [weak self] _ in
        self?.open(urlString: googleURLString, errorCompletion: {})
      }))
    }

    alert.addAction(UIAlertAction(title: localized("cancel").firstLetterUppercased(), style: .cancel, handler: nil))
    alert.view.tintColor = .accent
    alert.popoverPresentationController?.sourceView = button
    alert.popoverPresentationController?.permittedArrowDirections = .up

    viewController?.present(alert, animated: true, completion: nil)
  }
}
