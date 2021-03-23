//
//  LocationService.swift
//  LocationUI
//
//  Created by Алексей Смирнов on 03.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreLocation
import Combine

public enum Location {
  
  public enum Status {
    case notDetermined
    case denied
    case allowed
  }
  
  public enum Error: Swift.Error {
    case failed(error: Swift.Error)
    case denied
    case notDetermined
  }
}

public protocol LocationServiceProtocol {
  func requestUserPermission(completion: @escaping (Bool) -> Void)
  func requestLocation(completion: @escaping (Result<CLLocation, Location.Error>) -> Void)
}

public final class LocationService: NSObject {
  
  /*private*/public lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    return locationManager
  }()
  
  private var onRequestLocation: ((Result<CLLocation, Location.Error>) -> Void)?
  private var onRequestPermission: ((Bool) -> Void)?
}

// MARK: - LocationServiceProtocol

extension LocationService: LocationServiceProtocol {
  
  private var permissionStatus: Location.Status {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      return .notDetermined
      
    case .restricted, .denied:
      return .denied
      
    case .authorizedAlways, .authorizedWhenInUse:
      return .allowed
      
    @unknown default:
      return .denied
    }
  }
  
  public func requestUserPermission(completion: @escaping (Bool) -> Void) {
    onRequestPermission = completion
    locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
        locationManager.startUpdatingLocation()
    }
  }
  
  public func requestLocation(completion: @escaping (Result<CLLocation, Location.Error>) -> Void) {
    let status = permissionStatus
    switch status {
    case .notDetermined:
      completion(.failure(.notDetermined))
      
    case .denied:
      completion(.failure(.denied))
      
    case .allowed:
      if let location = locationManager.location {
        completion(.success(location))
      } else {
        onRequestLocation = completion
        locationManager.requestLocation()
      }
    }
  }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
  
  public func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation])
  {
    guard let location = locations.last else { return }
    onRequestLocation?(.success(location))
    onRequestLocation = nil
  }
  
  public func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error)
  {
    onRequestLocation?(.failure(.failed(error: error)))
    onRequestLocation = nil
  }
  
  public func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus)
  {
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      onRequestPermission?(true)
      onRequestPermission = nil
      
    case .restricted, .denied:
      onRequestPermission?(false)
      onRequestPermission = nil
      
    case .notDetermined: ()
      
    @unknown default: ()
    }
  }
}

public enum MapError: Error {
  case locationPermissionDenied
}

public extension LocationService {
  
  func requestLocation() -> AnyPublisher<CLLocation, Location.Error> {
    Deferred {
      Future { promise in
        self.requestLocation { result in
          promise(result)
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  func requestUserPermission() -> AnyPublisher<Bool, Never> {
    Deferred {
      Future { promise in
        self.requestUserPermission { isGranted in
          promise(.success(isGranted))
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  func requestIfUndefined(_ error: Location.Error) -> AnyPublisher<CLLocation, Location.Error> {
    switch error {
    case .failed, .denied:
      return Fail(error: error).eraseToAnyPublisher()
    case .notDetermined:
      return requestUserPermission()
        .mapError({ (error) -> Location.Error in
          .failed(error: error)
        })
        .flatMap { isGranter in
          isGranter ?
            self.requestLocation() :
            Fail(error: Location.Error.denied)
            .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
  }
  
  func getLocation() -> AnyPublisher<CLLocationCoordinate2D, Location.Error> {
    requestLocation()
      .catch(requestIfUndefined)
      .map { $0.coordinate }
      .eraseToAnyPublisher()
  }
}
