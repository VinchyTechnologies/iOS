//
//  VinchyRepository.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Combine
import Core
import CoreLocation
import LocationUI
import VinchyAuthorization
import VinchyCore

// MARK: - VinchyRepository

final class VinchyRepository {

  // MARK: Lifecycle

  init(locationService: LocationService, authService: AuthService) {
    self.locationService = locationService
    self.authService = authService
  }

  // MARK: Private

  private let locationService: LocationService
  private let authService: AuthService
  private var subscriptions = Set<AnyCancellable>()

  private func requestNearestPartnersData(
    userLocation: CLLocationCoordinate2D?,
    radius: Int)
    -> AnyPublisher<[NearestPartner], Error>
  {
    if let userLocation = userLocation {
      return fetchNearestPartnersAPI(userLocation: userLocation, radius: radius)
    } else {
      return performFullPipeline(radius: radius)
    }
  }

  private func performFullPipeline(radius: Int) -> AnyPublisher<[NearestPartner], Error> {
    locationService
      .getLocation()
      .mapError { _ in MapError.locationPermissionDenied }
      .flatMap {
        self.fetchNearestPartnersAPI(userLocation: $0, radius: radius)
      }
      .eraseToAnyPublisher()
  }

  private func getUserLocation() -> AnyPublisher<CLLocationCoordinate2D, Error> {
    locationService
      .getLocation()
      .mapError { _ in MapError.locationPermissionDenied }
      .eraseToAnyPublisher()
  }

  private func fetchNearestPartnersAPI(
    userLocation: CLLocationCoordinate2D,
    radius: Int)
    -> AnyPublisher<[NearestPartner], Error>
  {
    Deferred {
      Future { promise in
        Partners.shared.getNearestPartners(
          numberOfPartners: 4,
          latitude: userLocation.latitude,
          longitude: userLocation.longitude,
          radius: radius,
          accountID: UserDefaultsConfig.accountID,
          completion: { result in
            promise(result)
          })
      }
    }
    .mapError { $0 }
    .map { $0 as [NearestPartner] }
    .eraseToAnyPublisher()
  }
}

// MARK: VinchyRepositoryProtocol

extension VinchyRepository: VinchyRepositoryProtocol {
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

  func requestNearestPartners(
    userLocation: CLLocationCoordinate2D?,
    radius: Int,
    completion: @escaping (Result<[NearestPartner], Error>) -> Void)
  {
    let apiSubscription = requestNearestPartnersData(userLocation: userLocation, radius: radius)
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
