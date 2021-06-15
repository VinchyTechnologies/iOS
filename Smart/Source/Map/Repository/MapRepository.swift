//
//  MapRepository.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Combine
import CoreLocation
import LocationUI
import VinchyCore

// MARK: - MapRepository

final class MapRepository {

  // MARK: Lifecycle

  init(locationService: LocationService) {
    self.locationService = locationService
  }

  // MARK: Private

  private let locationService: LocationService
  private var subscriptions = Set<AnyCancellable>()

  private func requestPartnersData(
    userLocation: CLLocationCoordinate2D?,
    radius: Int)
    -> AnyPublisher<[PartnerOnMap], Error>
  {
    if let userLocation = userLocation {
      return fetchPartnersAPI(userLocation: userLocation, radius: radius)
    } else {
      return performFullPipeline(radius: radius)
    }
  }

  private func performFullPipeline(radius: Int) -> AnyPublisher<[PartnerOnMap], Error> {
    locationService
      .getLocation()
      .mapError { _ in MapError.locationPermissionDenied }
      .flatMap {
        self.fetchPartnersAPI(userLocation: $0, radius: radius)
      }
      .eraseToAnyPublisher()
  }

  private func getUserLocation() -> AnyPublisher<CLLocationCoordinate2D, Error> {
    locationService
      .getLocation()
      .mapError { _ in MapError.locationPermissionDenied }
      .eraseToAnyPublisher()
  }

  private func fetchPartnersAPI(userLocation: CLLocationCoordinate2D, radius: Int) -> AnyPublisher<[PartnerOnMap], Error> {
    Deferred {
      Future { promise in
        Partners.shared.getPartnersOnMap(
          latitude: userLocation.latitude,
          longitude: userLocation.longitude,
          radius: radius,
          completion: { result in
            promise(result)
          })
      }
    }
    .mapError { $0 }
    .map { $0 as [PartnerOnMap] }
    .eraseToAnyPublisher()
  }
}

// MARK: MapRepositoryProtocol

extension MapRepository: MapRepositoryProtocol {
  func requestUserLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
    let subscription = getUserLocation()
      .receive(on: DispatchQueue.main)
      .sink { receivedCompletion in
        guard case .failure = receivedCompletion else { return }
        completion(nil)
      } receiveValue: { response in
        completion(response)
      }
    subscriptions.insert(subscription)
  }

  func requestPartners(
    userLocation: CLLocationCoordinate2D?,
    radius: Int,
    completion: @escaping (Result<[PartnerOnMap], Error>) -> Void)
  {
    let apiSubscription = requestPartnersData(userLocation: userLocation, radius: radius)
      .receive(on: DispatchQueue.main)
      .sink { receivedCompletion in
        guard case .failure(let error) = receivedCompletion else { return }
        completion(.failure(error))
      } receiveValue: { response in
        completion(.success(response))
      }
    subscriptions.insert(apiSubscription)
  }
}
