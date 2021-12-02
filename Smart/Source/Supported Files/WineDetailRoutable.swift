//
//  WineDetailRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import VinchyUI
import WineDetail

extension WineDetailRoutable {
  func pushToWineDetailViewController(wineID: Int64) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      presentWineDetailViewController(wineID: wineID)
    } else {
      let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID), coordinator: Coordinator.shared)
      controller.hidesBottomBarWhenPushed = true
      UIApplication.topViewController()?.navigationController?.pushViewController(
        controller,
        animated: true)
    }
  }

  func presentWineDetailViewController(wineID: Int64) {
    let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID), coordinator: Coordinator.shared)
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .overFullScreen
    UIApplication.topViewController()?.present(
      navigationController,
      animated: true,
      completion: nil)
  }
}
