//
//  ShowcaseRoutable.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 4/2/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol ShowcaseRoutable: AnyObject {

  var viewController: UIViewController? { get }

  func pushToShowcaseViewController(input: ShowcaseInput)
}

extension ShowcaseRoutable {

  func pushToShowcaseViewController(input: ShowcaseInput) {
    viewController?.navigationController?.pushViewController(
      Assembly.buildShowcaseModule(input: input),
      animated: true)
  }
}
