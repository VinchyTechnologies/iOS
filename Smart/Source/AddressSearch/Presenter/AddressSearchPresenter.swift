//
//  AddressSearchPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import MapKit
import StringFormatting

// MARK: - AddressSearchPresenter

final class AddressSearchPresenter {

  // MARK: Lifecycle

  init(viewController: AddressSearchViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: AddressSearchViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = AddressSearchViewModel

}

// MARK: AddressSearchPresenterProtocol

extension AddressSearchPresenter: AddressSearchPresenterProtocol {

  var alertLocationServiceSettingsTitleText: String? {
    "Мы не знаем где вы..."
  }

  var alertLocationServiceSettingSubtitleText: String? {
    "Это включается в настройках"
  }

  var alertLocationServiceSettingsLeadingButtonText: String? {
    "Потом"
  }

  var alertLocationServiceSettingsTrailingButtonText: String? {
    "Hастройки"
  }

  func update(response: [CLPlacemark]?) {
    var sections: [AddressSearchViewModel.Section] = []

    sections += [.currentGeo(.init(id: response?.capacity ?? 0, title: "Current Geo", body: nil, systemImageName: "location.fill"))]

    sections += response?.enumerated().compactMap({
      AddressSearchViewModel.Section.address(
        .init(id: $0.offset, title: $0.element.name ?? "", body: nil))
    }) ?? []

    viewController?.updateUI(viewModel: .init(sections: sections, navigationTitleText: localized("address_search")))
  }
}
