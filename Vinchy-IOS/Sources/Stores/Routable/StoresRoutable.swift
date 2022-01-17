//
//  StoresRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

extension StoresRoutable {
  func pushToStoresViewController(wineID: Int64) {
    let controller = StoresAssembly.assemblyModule(input: .init(mode: .wine(wineID: wineID)))
    controller.hidesBottomBarWhenPushed = true
    UIApplication.topViewController()?.navigationController?.pushViewController(
      controller,
      animated: true)
  }
}
