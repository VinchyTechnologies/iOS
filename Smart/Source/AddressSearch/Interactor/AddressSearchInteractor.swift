//
//  AddressSearchInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import MapKit

// MARK: - AddressSearchInteractor

final class AddressSearchInteractor {

  // MARK: Lifecycle

  init(
    router: AddressSearchRouterProtocol,
    presenter: AddressSearchPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: AddressSearchRouterProtocol
  private let presenter: AddressSearchPresenterProtocol
  private let throttler = Throttler()
  private var response: [CLPlacemark] = []
  private let geoCoder = CLGeocoder()
}

// MARK: AddressSearchInteractorProtocol

extension AddressSearchInteractor: AddressSearchInteractorProtocol {
  func didTapGoToSettingToTurnOnLocationService() {
    if
      let bundleId = Bundle.main.bundleIdentifier,
      let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
    {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }

  func didSelectCurrentGeo() {

    switch CLLocationManager.authorizationStatus() {
    case .notDetermined, .restricted:
      return

    case .denied:
      router.showAlertTurnOnLocationViaSettingOnly(
        titleText: presenter.alertLocationServiceSettingsTitleText,
        subtitleText: presenter.alertLocationServiceSettingSubtitleText,
        leadingButtonText: presenter.alertLocationServiceSettingsLeadingButtonText,
        trailingButtonText: presenter.alertLocationServiceSettingsTrailingButtonText)

    case .authorizedAlways, .authorizedWhenInUse:
      UserDefaultsConfig.shouldUseCurrentGeo = true
      router.dismiss()

    @unknown default:
      return
    }
  }

  func didSelectAddressRow(id: Int) {
    if let placeMark = response[safe: id] {
      UserDefaultsConfig.userLatitude = placeMark.location?.coordinate.latitude ?? 0
      UserDefaultsConfig.userLongtitude = placeMark.location?.coordinate.longitude ?? 0
    }
    router.dismiss()
  }

  func didEnterSearchText(_ text: String?) {
    guard
      let searchText = text,
      !searchText.isEmpty
    else {
      presenter.update(response: nil)
      return
    }
    throttler.cancel()

    throttler.throttle(delay: .milliseconds(600)) { [weak self] in
      self?.geoCoder.geocodeAddressString(searchText) { response, _ in
        self?.response = response ?? []
        self?.presenter.update(response: response)
      }
    }
  }

  func viewDidLoad() {
    presenter.update(response: nil)
  }
}
