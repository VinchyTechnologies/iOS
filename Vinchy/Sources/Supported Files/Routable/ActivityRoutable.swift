//
//  ActivityRoutable.swift
//  Smart
//
//  Created by Михаил Исаченко on 02.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

// MARK: - ActivityRoutable

extension ActivityRoutable {
  func presentActivityViewController(items: [Any], sourceView: UIView) {
    let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
    if let popoverController = controller.popoverPresentationController {
      popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
      popoverController.sourceView = sourceView
    }
    UIApplication.topViewController()?.present(controller, animated: true)
  }
}
