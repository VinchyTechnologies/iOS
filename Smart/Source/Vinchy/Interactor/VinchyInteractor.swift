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

    result = Array(result.prefix(5))

    return result
  }

  private func fetchData() {

    var compilations: [Compilation] = []
    var nearestPartners: [NearestPartner] = []
    var isLocationPermissionDenied: Bool = false

    dispatchGroup.enter()
    Compilations.shared.getCompilations { [weak self] result in
      switch result {
      case .success(let model):
        compilations = model

      case .failure(let error):
        print(error.localizedDescription)
      }

      self?.dispatchGroup.leave()
    }

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
              isLocationPermissionDenied = true
//              self.repository.requestNearestPartners(
//                userLocation: CLLocationCoordinate2D(latitude: 55.755786, longitude: 37.617633),
//                radius: 10000) { [weak self] result in
//                  guard let self = self else { return }
//                  switch result {
//                  case .success(let response):
//                    nearestPartners = self.convertToFiveNearestStores(nearestPartners: response, userLocation: userLocation)
//
//                  case .failure(let error):
//                    print(error.localizedDescription)
//                  }
              self.dispatchGroup.leave()
//              }
            } else {
              print(error.localizedDescription)
              self.dispatchGroup.leave()
            }
          }
      }
    }

    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let self = self else { return }

      if isShareUsEnabled {
        let shareUs = Compilation(type: .shareUs, imageURL: nil, title: nil, collectionList: [])
        compilations.insert(shareUs, at: compilations.isEmpty ? 0 : min(3, compilations.count - 1))
      }

      if isSmartFilterAvailable {
        let smartFilter = Compilation(type: .smartFilter, imageURL: nil, title: nil, collectionList: [])
        compilations.insert(smartFilter, at: 1)
      }

      self.nearestPartners = nearestPartners

      self.compilations = compilations

      if let userLocation = self.userLocation {
        CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude).fetchCityAndCountry { city, _, _ in
          self.presenter.update(
            compilations: compilations,
            nearestPartners: nearestPartners,
            city: city,
            isLocationPermissionDenied: isLocationPermissionDenied)
        }
      } else {
        self.presenter.update(
          compilations: compilations,
          nearestPartners: nearestPartners,
          city: nil,
          isLocationPermissionDenied: isLocationPermissionDenied)
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
    fetchData()
  }

  func didPullToRefresh() {
    fetchData()
    presenter.stopPullRefreshing()
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
      completion($0?.first?.locality, $0?.first?.country, $1)
    }
  }
}
