//
//  VinchyInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import CoreLocation
import Database
import LocationUI
import VinchyCore

// MARK: - VinchyInteractor

final class VinchyInteractor {

  // MARK: Lifecycle

  init(
    router: VinchyRouterProtocol,
    presenter: VinchyPresenterProtocol,
    repository: VinchyRepositoryProtocol)
  {
    self.router = router
    self.presenter = presenter
    self.repository = repository
  }

  // MARK: Private

  private let dispatchGroup = DispatchGroup()
  private let throttler = Throttler()

  private let router: VinchyRouterProtocol
  private let presenter: VinchyPresenterProtocol
  private let repository: VinchyRepositoryProtocol

  private var compilations: [Compilation] = []
  private var nearestPartners: [NearestPartner] = []
  private var userLocation: CLLocationCoordinate2D?

  private func convertToFiveNearestStores(
    nearestPartners: [NearestPartner],
    userLocation: CLLocationCoordinate2D?) -> [NearestPartner]
  {
    let userLocation = userLocation ?? CLLocationCoordinate2D(latitude: 55.755786, longitude: 37.617633)
    let nearestPartnersTulp: [(NearestPartner, Double)] = nearestPartners.compactMap { store in
      if let latitude = store.partner.latitude, let longitude = store.partner.longitude {
        return (store, CLLocation.distance(from: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), to: userLocation))
      }
      return nil
    }
    .sorted(by: { $0.1 < $1.1 })

    var result = [NearestPartner]()

    for partner in nearestPartnersTulp {
      if !result.contains(where: { $0.partner.title == partner.0.partner.title }) {
        result.append(partner.0)
      }
    }

    result = Array(result.prefix(3))

    return result
  }

  private func fetchData(isViaPullToRefresh: Bool) {

    var compilations: [Compilation] = []
    var nearestPartners: [NearestPartner] = []
    var error: Error?

    dispatchGroup.enter()
    Compilations.shared.getCompilations { [weak self] result in
      switch result {
      case .success(let model):
        compilations = model

      case .failure(let errorResponse):
        error = errorResponse
      }

      self?.dispatchGroup.leave()
    }

    if UserDefaultsConfig.shouldUseCurrentGeo {
      dispatchGroup.enter()
      repository.requestUserLocation { [weak self] userLocation in
        self?.userLocation = userLocation
        self?.repository.requestNearestPartners(
          userLocation: userLocation,
          radius: 10000) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
              nearestPartners = self.convertToFiveNearestStores(nearestPartners: response, userLocation: userLocation)
              self.dispatchGroup.leave()

            case .failure(let error):
              if case MapError.locationPermissionDenied = error { // TODO: - move all to repository
                UserDefaultsConfig.shouldUseCurrentGeo = false
              }
              self.dispatchGroup.leave()
            }
        }
      }
    } else {
      if !(UserDefaultsConfig.userLatitude == 0 && UserDefaultsConfig.userLongtitude == 0) {
        dispatchGroup.enter()
        repository.requestNearestPartners(
          userLocation: CLLocationCoordinate2D(latitude: UserDefaultsConfig.userLatitude, longitude: UserDefaultsConfig.userLongtitude),
          radius: 10000) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
              nearestPartners = self.convertToFiveNearestStores(nearestPartners: response, userLocation: CLLocationCoordinate2D(latitude: UserDefaultsConfig.userLatitude, longitude: UserDefaultsConfig.userLongtitude))

            case .failure(let error):
              print(error.localizedDescription)
            }
            self.dispatchGroup.leave()
        }
      }
    }

    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let self = self else { return }

      self.nearestPartners = nearestPartners

      self.compilations = compilations

      if let userLocation = self.userLocation, UserDefaultsConfig.shouldUseCurrentGeo {
        CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude).fetchCityAndCountry { city, _, _ in
          self.presenter.update(
            compilations: compilations,
            nearestPartners: nearestPartners,
            city: city,
            isLocationPermissionDenied: false,
            userLocation: userLocation,
            didUsePullToRefresh: isViaPullToRefresh,
            error: error)
        }
      } else {
        if UserDefaultsConfig.userLatitude != 0 && UserDefaultsConfig.userLongtitude != 0 {
          CLLocation(
            latitude: UserDefaultsConfig.userLatitude,
            longitude: UserDefaultsConfig.userLongtitude).fetchCityAndCountry { city, _, _ in
            self.presenter.update(
              compilations: compilations,
              nearestPartners: nearestPartners,
              city: city,
              isLocationPermissionDenied: false,
              userLocation: CLLocationCoordinate2D(latitude: UserDefaultsConfig.userLatitude, longitude: UserDefaultsConfig.userLongtitude),
              didUsePullToRefresh: isViaPullToRefresh,
              error: error)
          }
        } else {
          self.presenter.update(
            compilations: compilations,
            nearestPartners: nearestPartners,
            city: nil,
            isLocationPermissionDenied: true,
            userLocation: nil,
            didUsePullToRefresh: isViaPullToRefresh,
            error: error)
        }
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        if self.userLocation != nil {
          let partnersAndDistances: [(NearestPartner, CLLocationDistance)] = nearestPartners.compactMap { nearestPartner in

            guard let latitude = nearestPartner.partner.latitude, let longitude = nearestPartner.partner.longitude else {
              return nil
            }
            return (nearestPartner, CLLocation.distance(from: self.userLocation!, to: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
          }

          guard let nearestStore = partnersAndDistances.min(by: { $0.1 < $1.1 }) else {
            return
          }

          if nearestStore.1 <= 100 {
            self.router.presentAreYouInStoreBottomSheet(nearestPartner: nearestStore.0)
          }
        }
      }
    }
  }
}

// MARK: VinchyInteractorProtocol

extension VinchyInteractor: VinchyInteractorProtocol {

  var contextMenuRouter: ActivityRoutable & WriteNoteRoutable {
    router
  }

  func didChangeAddress() {
    presenter.startShimmer()
    fetchData(isViaPullToRefresh: false)
  }

  func didTapChangeAddressButton() {
    router.presentChangeAddressViewController()
  }

  func didTapSeeStore(affilatedId: Int) {
    router.pushToStoreViewController(affilatedId: affilatedId)
  }

  func didTapSearchButton(searchText: String?) {
    guard let searchText = searchText else {
      return
    }

    router.pushToDetailCollection(searchText: searchText)
  }

  func viewDidLoad() {
    presenter.startShimmer()
    fetchData(isViaPullToRefresh: false)
  }

  func didPullToRefresh() {
    presenter.startShimmer()
    fetchData(isViaPullToRefresh: true)
  }

  func didTapFilter() {
    router.pushToAdvancedFilterViewController()
  }

  func didTapMapButton() {
    router.pushToMapViewController()
  }
}

// MARK: - VinchySimpleConiniousCaruselCollectionCellDelegate

extension VinchyInteractor {
  func didTapBottleCell(wineID: Int64) {
    router.pushToWineDetailViewController(wineID: wineID)
  }

  func didTapCompilationCell(input: ShowcaseInput) {
    switch input.mode {
    case .normal(let wines):
      guard !wines.isEmpty else {
        presenter.showAlertEmptyCollection()
        return
      }

    case .advancedSearch, .partner:
      break
    }

    router.pushToShowcaseViewController(input: input)
  }
}

extension CLLocation {
  func fetchCityAndCountry(
    completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> Void)
  {
    CLGeocoder().reverseGeocodeLocation(self) {
      completion($0?.first?.name, $0?.first?.country, $1)
    }
  }
}
