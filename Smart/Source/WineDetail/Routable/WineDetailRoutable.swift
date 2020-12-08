//
//  WineDetailRoutable.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol WineDetailRoutable: AnyObject {

  var viewController: UIViewController? { get }

  func pushToWineDetailViewController(wineID: Int64)
}

extension WineDetailRoutable {

  func pushToWineDetailViewController(wineID: Int64) {
    viewController?.navigationController?.pushViewController(
      Assembly.buildDetailModule(wineID: wineID),
      animated: true)
  }
}
