//
//  WineDetailRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import UIKit
import VinchyUI
import WineDetail

extension WineDetailRoutable {
  func pushToWineDetailViewController(wineID: Int64, mode: WineDetailMode) {
    if UIDevice.current.userInterfaceIdiom == .pad && UIApplication.topViewController() is SearchViewController {
      presentWineDetailViewController(wineID: wineID, mode: mode)
    } else {
      let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID, mode: mode, isAppClip: false), coordinator: Coordinator.shared, adGenerator: AdFabric.shared)
      controller.hidesBottomBarWhenPushed = true
      if UIApplication.topViewController() is SearchViewController {
        UIApplication.topViewController()?.presentingViewController?.navigationController?.pushViewController(
          controller,
          animated: true)
      } else {
        UIApplication.topViewController()?.navigationController?.pushViewController(
          controller,
          animated: true)
      }
    }
  }

  func presentWineDetailViewController(wineID: Int64, mode: WineDetailMode) {
    let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID, mode: mode, isAppClip: false), coordinator: Coordinator.shared, adGenerator: AdFabric.shared)
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .overFullScreen
    UIApplication.topViewController()?.present(
      navigationController,
      animated: true,
      completion: nil)
  }
}
