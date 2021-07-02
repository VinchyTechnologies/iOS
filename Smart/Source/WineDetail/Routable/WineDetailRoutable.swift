//
//  WineDetailRoutable.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display

// MARK: - WineDetailRoutable

protocol WineDetailRoutable: AnyObject {
  var viewController: UIViewController? { get }

  func pushToWineDetailViewController(wineID: Int64)

  func presentWineDetailViewController(wineID: Int64)
}

extension WineDetailRoutable {
  func pushToWineDetailViewController(wineID: Int64) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      presentWineDetailViewController(wineID: wineID)
    } else {
      let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID))
      controller.hidesBottomBarWhenPushed = true
      viewController?.navigationController?.pushViewController(
        controller,
        animated: true)
    }
  }

  func presentWineDetailViewController(wineID: Int64) {
    let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID))
    let navigationController = NavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .fullScreen
    UIApplication.topViewController()?.present(
      navigationController,
      animated: true,
      completion: nil)
//    viewController?.present(
//      navigationController,
//      animated: true)
  }
}
