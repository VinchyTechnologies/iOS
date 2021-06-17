//
//  OnboardingModuleFactory.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class OnboardingModuleFactory {
  func makeOnboardingViewController(
    delegate: OnboardingViewControllerOutput?)
    -> OnboardViewController
  {
    let pageItems: [OnboardPage] = [OnboardPage(title: "title", description: "description")]
    let viewController = OnboardViewController(pageItems: pageItems)
    viewController.delegate = delegate
    return viewController
  }
}
