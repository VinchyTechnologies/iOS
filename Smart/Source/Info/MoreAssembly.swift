//
//  MoreAssembly.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import UIKit
import StringFormatting

final class MoreAssembly {
  static func assemblyModel() -> MoreViewController {
    let viewController = MoreViewController()
    
    let router = MoreRouter(viewController: viewController)
    let presenter = MorePresenter(view: viewController)
    let interactor = MoreInteractor(presenter: presenter, router: router)
    
    viewController.interactor = interactor
    
    return viewController
  }
}
