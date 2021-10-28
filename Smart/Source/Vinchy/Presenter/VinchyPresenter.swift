//
//  VinchyPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import CoreLocation
import Display
import MapKit
import StringFormatting
import UIKit
import VinchyCore

// MARK: - VinchyPresenter

final class VinchyPresenter {

  // MARK: Lifecycle

  init(viewController: VinchyViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: VinchyViewControllerProtocol?

  // MARK: Private

  private enum C {
    static let harmfulToYourHealthText = localized("harmful_to_your_health")
  }

  private func map(route: MKRoute?) -> String? {
    guard let route = route else {
      return nil
    }
    let subtitle: String = (route.distance.toDistance() ?? "")
      + " • "
      + (route.expectedTravelTime.toString() ?? "")
      + " " + localized("walking")

    return subtitle
  }

  private func getDistance(
    location1: CLLocation,
    location2: CLLocation,
    completion: @escaping (MKRoute?) -> Void)
  {
    let coordinates1 = location1.coordinate
    let placemark1 = MKPlacemark(coordinate: coordinates1)
    let sourceItem = MKMapItem(placemark: placemark1)
    let coordinates2 = location2.coordinate
    let placemark2 = MKPlacemark(coordinate: coordinates2)
    let destinationItem = MKMapItem(placemark: placemark2)

    let request = MKDirections.Request()
    request.source = sourceItem
    request.destination = destinationItem
    request.requestsAlternateRoutes = true
    request.transportType = .walking

    let directions = MKDirections(request: request)
    directions.calculate { response, _ in
      if var routeResponse = response?.routes {
        routeResponse.sort(by: { $0.expectedTravelTime < $1.expectedTravelTime })
        let quickestRoute: MKRoute? = routeResponse.first
        completion(quickestRoute)
      } else {
        completion(nil)
      }
    }
  }

  private func getDistanceArray(
    userLocation: CLLocationCoordinate2D?,
    nearestPartners: [NearestPartner],
    completion: @escaping ([(NearestPartner, String?)]) -> Void)
  {
    if let userLocation = userLocation
    {
      let uLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
      let group = DispatchGroup()
      var distanceArray: [(NearestPartner, MKRoute?)] = []

      for partner in nearestPartners {

        if let lat = partner.partner.latitude, let lon = partner.partner.longitude {
          let storeLocation = CLLocation(latitude: lat, longitude: lon)
          group.enter()
          getDistance(location1: storeLocation, location2: uLocation) { route in
            distanceArray.append((partner, route))
            group.leave()
          }
        } else {
          distanceArray.append((partner, nil))
          group.leave()
        }
      }

      group.notify(queue: .main) { [weak self] in
        let distanceArray = distanceArray.sorted { arg1, arg2 in
          guard let route1 = arg1.1, let route2 = arg2.1 else {
            return false
          }
          return route1.expectedTravelTime < route2.expectedTravelTime
        }.map { arg -> (NearestPartner, String?) in
          (arg.0, self?.map(route: arg.1))
        }

        completion(distanceArray)
      }
    }
  }
}

// MARK: VinchyPresenterProtocol

extension VinchyPresenter: VinchyPresenterProtocol {

  func showAlertEmptyCollection() {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: localized("empty_collection"))
  }

  func stopPullRefreshing() {
    viewController?.stopPullRefreshing()
  }

  func startShimmer() {
    viewController?.updateUI(
      viewModel: VinchyViewControllerViewModel(
        state: .fake(sections: [
          .stories(content: Array(repeating: FakeView.Content(), count: 10)),
          .title(content: Array(repeating: FakeView.Content(), count: 1)),
          .promo(content: Array(repeating: FakeView.Content(), count: 10)),
          .title(content: Array(repeating: FakeView.Content(), count: 1)),
          .big(content: Array(repeating: FakeView.Content(), count: 10)),
          .title(content: Array(repeating: FakeView.Content(), count: 1)),
          .promo(content: Array(repeating: FakeView.Content(), count: 10)),
          .title(content: Array(repeating: FakeView.Content(), count: 1)),
          .big(content: Array(repeating: FakeView.Content(), count: 10)),
          .title(content: Array(repeating: FakeView.Content(), count: 1)),
          .promo(content: Array(repeating: FakeView.Content(), count: 10)),
        ]),
        leadingAddressButtonViewModel: .loading(text: localized("loading").firstLetterUppercased())))
  }

  func update(
    compilations: [Compilation],
    nearestPartners: [NearestPartner],
    city: String?,
    isLocationPermissionDenied: Bool,
    userLocation: CLLocationCoordinate2D?,
    didUsePullToRefresh: Bool, error: Error?)
  {
    if error != nil {
      viewController?.updateUI(viewModel: .init(
        state: .error(
          sections: [
            .common(content: .init(
              titleText: localized("error").firstLetterUppercased(),
              subtitleText: error?.localizedDescription,
              buttonText: localized("reload").firstLetterUppercased())),
          ]), leadingAddressButtonViewModel: .loading(text: localized("undefined").firstLetterUppercased())))
      if didUsePullToRefresh {
        viewController?.stopPullRefreshing()
      }
      return
    }

    getDistanceArray(userLocation: userLocation, nearestPartners: nearestPartners) { [weak self] result in
      var sections: [VinchyViewControllerViewModel.Section] = []

      if
        let storiesCompilation = compilations.first(where: {
          $0.type == .mini && ($0.title == nil || $0.title == "")
        })
      {
        sections.append(.stories(content: storiesCompilation.collectionList.compactMap({ collection in
          .init(imageURL: collection.imageURL?.toURL, titleText: collection.title, wines: collection.wineList)
        })))
      }

      if !nearestPartners.isEmpty {
        sections.append(.nearestStoreTitle(content: localized("nearest_stores")))
      }

      result.forEach { nearestPartner, subtitleText in
        sections.append(.storeTitle(content: .init(affilatedId: nearestPartner.partner.affiliatedStoreId, titleText: nearestPartner.partner.title, logoURL: nearestPartner.partner.logoURL, subtitleText: subtitleText, moreText: localized("more").firstLetterUppercased())))

        sections.append(.bottles(content: nearestPartner.recommendedWines.compactMap({
          .init(wineID: $0.id, imageURL: $0.mainImageUrl?.toURL, titleText: $0.title, subtitleText: countryNameFromLocaleCode(countryCode: $0.winery?.countryCode), rating: $0.rating, contextMenuViewModels: [])
        })))
      }

      for (index, compilation) in compilations.enumerated() {

        if index == 3 {
          sections.append(.shareUs(
            content: .init(titleText: localized("like_vinchy"))))
        }

        switch compilation.type {
        case .mini:
          if let title = compilation.title {
            sections.append(.title(content: title))
            sections.append(.stories(content: compilation.collectionList.compactMap({ collection in
              .init(imageURL: collection.imageURL?.toURL, titleText: collection.title, wines: collection.wineList)
            })))
          }

        case .big:
          if let title = compilation.title {
            sections.append(.title(content: title))
          }
          sections.append(.commonSubtitle(content: compilation.collectionList.compactMap({
            .init(subtitleText: $0.title, imageURL: $0.imageURL?.toURL, wines: $0.wineList)
          }), style: .init(kind: .big)))

        case .promo:
          if let title = compilation.title {
            sections.append(.title(content: title))
          }
          sections.append(.commonSubtitle(content: compilation.collectionList.compactMap({
            .init(subtitleText: $0.title, imageURL: $0.imageURL?.toURL, wines: $0.wineList)
          }), style: .init(kind: .promo)))

        case .bottles:
          if
            compilation.collectionList.first?.wineList != nil,
            let firstCollectionList = compilation.collectionList.first,
            !firstCollectionList.wineList.isEmpty
          {
            if let title = compilation.title {
              sections.append(.title(content: title))
            }

            sections.append(.bottles(content: firstCollectionList.wineList.compactMap({ wine in
              .init(wineID: wine.id, imageURL: wine.mainImageUrl?.toURL, titleText: wine.title, subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode), rating: wine.rating, contextMenuViewModels: [])
            })))
          }

        default:
          break
        }
      }

      sections.append(.harmfullToYourHealthTitle(content: C.harmfulToYourHealthText))

      // TODO: - if all empty

      self?.viewController?.updateUI(
        viewModel: VinchyViewControllerViewModel(
          state: .normal(sections: sections),
          leadingAddressButtonViewModel: isLocationPermissionDenied ? .arraw(text: localized("enter_address").firstLetterUppercased()) : .arraw(text: city)))
      if didUsePullToRefresh {
        self?.viewController?.stopPullRefreshing()
      }
    }
  }
}
