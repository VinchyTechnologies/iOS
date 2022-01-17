//
//  SafariRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import SafariServices
import UIKit
import VinchyUI

extension SafariRoutable {
  func presentSafari(url: URL) {
    let controller = SFSafariViewController(url: url)
    controller.preferredBarTintColor = .mainBackground
    controller.preferredControlTintColor = .accent
    UIApplication.topViewController()?.present(
      controller,
      animated: true)
  }
}
