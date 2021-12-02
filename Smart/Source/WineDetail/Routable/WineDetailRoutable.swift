//
//  WineDetailRoutable.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import VinchyUI

// MARK: - WineDetailRoutable

extension WineDetailRoutable {
  func pushToWineDetailViewController(wineID: Int64) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      presentWineDetailViewController(wineID: wineID)
    } else {
      let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID))
      controller.hidesBottomBarWhenPushed = true
      UIApplication.topViewController()?.navigationController?.pushViewController(
        controller,
        animated: true)
    }
  }

  func presentWineDetailViewController(wineID: Int64) {
    let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID))
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .overFullScreen
    UIApplication.topViewController()?.present(
      navigationController,
      animated: true,
      completion: nil)
  }
}
