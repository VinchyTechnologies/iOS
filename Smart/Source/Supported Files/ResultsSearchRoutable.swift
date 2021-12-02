//
//  ResultsSearchRoutable.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit
import VinchyUI

extension ResultsSearchRoutable {
  func pushToResultsSearchController(affilatedId: Int) {
    let controller = ResultsSearchAssembly.assemblyModule(
      input: .init(mode: .storeDetail(affilatedId: affilatedId)))
    let navController = VinchyNavigationController(rootViewController: controller)
    navController.modalPresentationStyle = .overCurrentContext
    UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
  }
}
