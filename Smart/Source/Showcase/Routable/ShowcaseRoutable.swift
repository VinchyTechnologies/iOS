//
//  ShowcaseRoutable.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 4/2/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyUI

// MARK: - ShowcaseRoutable

extension ShowcaseRoutable {
  func pushToShowcaseViewController(input: ShowcaseInput) {
    let controller = ShowcaseAssembly.assemblyModule(input: input)
    controller.hidesBottomBarWhenPushed = true
    UIApplication.topViewController()?.navigationController?.pushViewController(
      controller,
      animated: true)
  }
}
