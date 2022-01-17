//
//  DebugSettingsPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 14.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - DebugSettingsPresenter

final class DebugSettingsPresenter {

  // MARK: Lifecycle

  init(viewController: DebugSettingsViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: DebugSettingsViewControllerProtocol?

}

// MARK: DebugSettingsPresenterProtocol

extension DebugSettingsPresenter: DebugSettingsPresenterProtocol {
  func update() {

    var sections: [DebugSettingsViewModel.Section] = []

    sections += [
      .navigateVinchyStore(
        .init(
          id: 1,
          title: "Vinchy Store Test",
          body: nil)),
    ]

    #if DEBUG
    sections += [
      .navigateToPushNotification(
        .init(
          id: 2,
          title: "Push Notification Center",
          body: nil)),
    ]
    #endif

    viewController?.updateUI(viewModel: .init(
      sections: sections,
      navigationTitleText: "Debug"))
  }
}
