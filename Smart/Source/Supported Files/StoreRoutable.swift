//
//  StoreRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyStore
import VinchyUI

extension StoreRoutable {
  func pushToStoreViewController(affilatedId: Int) {
    let controller = StoreAssembly.assemblyModule(input: .init(mode: .normal(affilatedId: affilatedId)), coordinator: Coordinator.shared)
    controller.hidesBottomBarWhenPushed = true
    UIApplication.topViewController()?.navigationController?.pushViewController(
      controller,
      animated: true)
  }
}
