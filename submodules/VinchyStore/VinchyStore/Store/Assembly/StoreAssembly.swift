//
//  StoreAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

public final class StoreAssembly {

  public typealias Coordinator = WineDetailRoutable & ActivityRoutable & WriteNoteRoutable & AdvancedSearchRoutable & ResultsSearchRoutable

  public static func assemblyModule(input: StoreInput, coordinator: Coordinator, adFabricProtocol: AdFabricProtocol?) -> UIViewController {
    let viewController = StoreViewController(adGenerator: adFabricProtocol)
    let router = StoreRouter(input: input, viewController: viewController, coordinator: coordinator)
    let presenter = StorePresenter(viewController: viewController)
    let interactor = StoreInteractor(input: input, router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
