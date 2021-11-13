//
//  ActivityRoutable.swift
//  Smart
//
//  Created by Михаил Исаченко on 02.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - ActivityRoutable

protocol ActivityRoutable {
  var viewController: UIViewController? { get }
  func presentActivityViewController(items: [Any], sourceView: UIView)
}

extension ActivityRoutable {
  func presentActivityViewController(items: [Any], sourceView: UIView) {
    let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
    if let popoverController = controller.popoverPresentationController {
      popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
      popoverController.sourceView = sourceView
    }
    viewController?.present(controller, animated: true)
  }
}
