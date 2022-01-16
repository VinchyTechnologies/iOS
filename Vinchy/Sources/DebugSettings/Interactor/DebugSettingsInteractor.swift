//
//  DebugSettingsInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 14.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - DebugSettingsInteractor

final class DebugSettingsInteractor {

  // MARK: Lifecycle

  init(
    router: DebugSettingsRouterProtocol,
    presenter: DebugSettingsPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: DebugSettingsRouterProtocol
  private let presenter: DebugSettingsPresenterProtocol
}

// MARK: DebugSettingsInteractorProtocol

extension DebugSettingsInteractor: DebugSettingsInteractorProtocol {
  func didSelectOpenTestVinchyStore() {
    router.pushToVinchyStoreTestViewController()
  }

  func didSelectOpenPushNotifications() {
    router.pushToPushNotifications()
  }

  func viewDidLoad() {
    presenter.update()
  }
}
