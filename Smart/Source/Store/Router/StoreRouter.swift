//
//  StoreRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import AdvancedSearch
import CoreLocation
import Display
import StringFormatting
import UIKit

// MARK: - StoreRouter

final class StoreRouter {

  // MARK: Lifecycle

  init(
    input: StoreInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: StoreInteractorProtocol?

  // MARK: Private

  private let input: StoreInput

}

// MARK: StoreRouterProtocol

extension StoreRouter: StoreRouterProtocol {

  func presentFilter(preselectedFilters: [(String, String)]) {
    let controller = AdvancedSearchAssembly.assemblyModule(
      input: .init(mode: .asView(preselectedFilters: preselectedFilters)), coordinator: Coordinator.shared)
    let navController = AdvancedSearchNavigationController(rootViewController: controller)
    navController.advancedSearchOutputDelegate = interactor
    viewController?.present(navController, animated: true, completion: nil)
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
