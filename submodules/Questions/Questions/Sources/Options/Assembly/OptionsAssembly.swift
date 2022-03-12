//
//  OptionsAssembly.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import UIKit
import VinchyUI

public final class OptionsAssembly {

  public typealias Coordinator = ShowcaseRoutable

  public static func assemblyModule(input: OptionsInput, coordinator: Coordinator) -> UIViewController {
    let viewController = OptionsViewController()
    let router = OptionsRouter(input: input, viewController: viewController, coordinator: coordinator)
    let presenter = OptionsPresenter(input: input, viewController: viewController)
    let interactor = OptionsInteractor(input: input, router: router, presenter: presenter)
    viewController.interactor = interactor
    router.interactor = interactor
    return viewController
  }

}
