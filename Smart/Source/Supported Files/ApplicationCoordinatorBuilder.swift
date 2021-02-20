//
//  ApplicationCoordinatorBuilder.swift
//  Smart
//
//  Created by Aleksei Smirnov on 29.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class ApplicationCoordinatorBuilder {
  
  static func make(window: UIWindow?) -> ApplicationCoordinator? {
    
    guard let window = window else {
      return nil
    }
    
    let factory = ApplicationModulesFactoryImplementation(window: window)
    let onboardingRepository = OnboardingRepository(cache: OnboardingCacheImplementation())
    let appCoordinator = ApplicationCoordinator(window: window,
                                                applicationModulesFactory: factory,
                                                onboardingRepository: onboardingRepository)
    return appCoordinator
  }
}
