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
  
  var alertLocationServiceSettingsRestrictedTitle: String? {
    localized("restricted_geo_title")
  }
  
  var alertLocationServiceSettingsRestrictedSubtitle: String? {
    localized("restricted_geo_subtitle")
  }

  var alertLocationServiceSettingsTitleText: String? {
    localized("we_donot_know_where_you_are").firstLetterUppercased()
  }

  var alertLocationServiceSettingSubtitleText: String? {
    localized("let_us_know_your_location").firstLetterUppercased()
  }

  var alertLocationServiceSettingsLeadingButtonText: String? {
    localized("later").firstLetterUppercased()
  }

  var alertLocationServiceSettingsTrailingButtonText: String? {
    localized("settings").firstLetterUppercased()
  }

  func update(response: [CLPlacemark]?) {
    var sections: [AddressSearchViewModel.Section] = []

    sections += [.currentGeo(.init(id: response?.capacity ?? 0, title: localized("current_geo").firstLetterUppercased(), body: nil, systemImageName: "location.fill"))]

    sections += response?.enumerated().compactMap({
      AddressSearchViewModel.Section.address(
        .init(id: $0.offset, title: $0.element.name ?? "", body: nil))
    }) ?? []

    viewController?.updateUI(viewModel: .init(sections: sections, navigationTitleText: localized("address_search")))
  }
}
