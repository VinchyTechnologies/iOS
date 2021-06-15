//
//  ShowcaseRoutable.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 4/2/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - ShowcaseRoutable

protocol ShowcaseRoutable: AnyObject {
  var viewController: UIViewController? { get }

  func pushToShowcaseViewController(input: ShowcaseInput)
}

extension ShowcaseRoutable {
  func pushToShowcaseViewController(input: ShowcaseInput) {
    let controller = ShowcaseAssembly.assemblyModule(input: input)
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(
      controller,
      animated: true)
  }
}
