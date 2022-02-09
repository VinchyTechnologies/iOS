//
//  MapDetailStoreInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import CoreLocation
import UIKit.UIButton
import VinchyCore
import VinchyUI

// MARK: - MapDetailStoreInteractor

final class MapDetailStoreInteractor {

  // MARK: Lifecycle

  init(
    input: MapDetailStoreInput,
    router: MapDetailStoreRouterProtocol,
    presenter: MapDetailStorePresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let input: MapDetailStoreInput
  private let router: MapDetailStoreRouterProtocol
  private let presenter: MapDetailStorePresenterProtocol
  private let dispatchGroup = DispatchGroup()
  private let authService = AuthService.shared

  private var storeInfo: PartnerInfo?
  private var recommendedWines: [ShortWine] = []
  private var error: Error?

  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }

  private func fetchData() {
    dispatchWorkItemHud.perform()
    dispatchGroup.enter()
    dispatchGroup.enter()

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      Partners.shared.getPartnerStoreInfo(
        partnerId: self.input.partnerId,
        affilatedId: self.input.affilatedId) { [weak self] result in
          guard let self = self else { return }
          switch result {
          case .success(let response):
            self.storeInfo = response

          case .failure(let error):
            self.error = error
          }
          self.dispatchGroup.leave()
      }

      Recommendations.shared.getPersonalRecommendedWines(
        accountId: self.authService.currentUser?.accountID ?? 0,
        affilatedId: self.input.affilatedId) { [weak self] result in
          guard let self = self else { return }
          switch result {
          case .success(let response):
            self.recommendedWines += response

          case .failure(let error):
            print(error.localizedDescription)
          }
          self.dispatchGroup.leave()
      }
    }
  }
}

// MARK: MapDetailStoreInteractorProtocol

extension MapDetailStoreInteractor: MapDetailStoreInteractorProtocol {
  func viewDidLoad() {
    fetchData()

    dispatchGroup.notify(queue: .main) {
      self.dispatchWorkItemHud.cancel()
      DispatchQueue.main.async {
        self.presenter.stopLoading()
      }

      if let storeInfo = self.storeInfo {
        self.presenter.update(storeInfo: storeInfo, recommendedWines: self.recommendedWines)
      } else if let error = self.error {
        self.router.dismiss {
          self.presenter.showErrorAlert(error: error)
        }
      }
    }
  }

  func didTapRecommendedWine(wineID: Int64) {
    var mode: WineDetailMode = .normal
    if let wine = recommendedWines.first(where: { $0.id == wineID }), let price = wine.price {
      mode = .partner(affilatedId: input.affilatedId, price: price, buyAction: .openURL(url: wine.url?.toURL))
    }
    router.presentWineDetailViewController(wineID: wineID, mode: mode)
  }

  func didTapRouteButton(_ button: UIButton) {
    if let lat = storeInfo?.latitude, let lon = storeInfo?.longitude {
      router.showRoutesActionSheet(
        storeTitleText: storeInfo?.title,
        coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
        button: button)
    }
  }
}
