//
//  DebugSettingsRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 14.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import NotificationsDebug
import SwiftUI
import UIKit
import VinchyUI

// MARK: - DebugSettingsRouter

final class DebugSettingsRouter {

  // MARK: Lifecycle

  init(
    coordinator: StoreRoutable,
    viewController: UIViewController)
  {
    self.coordinator = coordinator
    self.viewController = viewController
  }

  // MARK: Internal

  let coordinator: StoreRoutable
  weak var viewController: UIViewController?
  weak var interactor: DebugSettingsInteractorProtocol?
}

// MARK: DebugSettingsRouterProtocol

extension DebugSettingsRouter: DebugSettingsRouterProtocol {
  func pushToVinchyStoreTestViewController() {
    coordinator.pushToStoreViewController(affilatedId: 1528)
  }

  func pushToPushNotifications() {
    viewController?.navigationController?.pushViewController(
      UIHostingController(rootView: NotificationDebugView()), animated: true)
  }
}
