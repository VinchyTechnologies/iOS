//
//  MapRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - MapRoutable

protocol MapRoutable: AnyObject {
  var viewController: UIViewController? { get }

  func pushToMapViewController()
}

extension MapRoutable {
  func pushToMapViewController() {
    let mapViewController = MapAssembly.assemblyModule()
    mapViewController.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(
      mapViewController,
      animated: true)
  }
}
