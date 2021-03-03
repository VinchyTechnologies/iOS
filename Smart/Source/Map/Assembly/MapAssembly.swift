//
//  MapAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class MapAssembly {
  
  static func assemblyModule() -> UIViewController {
    let viewController = MapViewController()
    let router = MapRouter(input: MapInput(), viewController: viewController)
    let presenter = MapPresenter(viewController: viewController)
    let interactor = MapInteractor(router: router, presenter: presenter)
    
    router.interactor = interactor
    viewController.interactor = interactor
    
    return viewController
  }
}
