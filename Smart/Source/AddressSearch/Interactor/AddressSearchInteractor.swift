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

}

// MARK: AddressSearchInteractorProtocol

extension AddressSearchInteractor: AddressSearchInteractorProtocol {

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
//      let request = MKLocalSearch.Request()
//      request.naturalLanguageQuery = searchText
//      let search = MKLocalSearch(request: request)
//      search.start { response, _ in
//        guard let response = response else {
//          return
//        }
//        self?.presenter.update(response: response)
//      }


      let geoCoder = CLGeocoder()
      geoCoder.geocodeAddressString(searchText) { response, error in
        guard let response = response else {
          return
        }
        self?.presenter.update(response: response)

      }
    }
  }

  func viewDidLoad() {
    presenter.update(response: nil)
  }
}
