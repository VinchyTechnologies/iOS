//
//  ApplicationCoordinator.swift
//  Smart
//
//  Created by Aleksei Smirnov on 28.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Core

final class ApplicationCoordinator: BaseCoordinator {
  
  // MARK: - Private Properties
  
  private let window: UIWindow
  private let applicationModulesFactory: ApplicationModulesFactory
  private let onboardingRepository: OnboardingRepositoryProtocol
  
  // MARK: - Initializers
  
  required init(
    window: UIWindow,
    applicationModulesFactory: ApplicationModulesFactory,
    onboardingRepository: OnboardingRepositoryProtocol) {
    self.window = window
    self.applicationModulesFactory = applicationModulesFactory
    self.onboardingRepository = onboardingRepository
  }
  
  // MARK: - Internal Methods
  
  override func start() {
    window.makeKeyAndVisible()
    startFlow()
  }
  
  // MARK: - Private Methods
  
  private func startFlow() {
    if !(UserDefaultsConfig.isAdult && UserDefaultsConfig.isAgreedToTermsAndConditions) {
      startAgreementFlow()
    } else if !onboardingRepository.isLastVersionOnboardingSeen() && isOnboardingAvailable {
      startOnboardingFlow()
    } else {
      startMainFlow()
    }
  }
  
  private func startAgreementFlow() {
    let navigationController = UINavigationController()
    let coordinator = applicationModulesFactory.buildAgreementsCoordinator(
      rootViewController: navigationController,
      closeDelegate: self)
    
    window.rootViewController = navigationController
    addChild(coordinator: coordinator)
    coordinator.start()
  }
  
  private func startOnboardingFlow() {
    
    let navigationController = UINavigationController()
    let coordinator = applicationModulesFactory.buildAOnboardingCoordinator(rootViewController: navigationController, closeDelegate: self)
    
    window.rootViewController = navigationController
    addChild(coordinator: coordinator)
    coordinator.start()
  }
  
  private func startMainFlow() {
    let coordinator = applicationModulesFactory.buildMainCoordinator()
    coordinator.start()
  }
}

extension ApplicationCoordinator: CoordinatorCloseDelegate {
  
  func didCloseCoordinator(_ coordinator: BaseCoordinator) {
    removeChild(coordinator: coordinator)
    
    switch coordinator {
    case is OnboardingCoordinator:
      onboardingRepository.setSawLastVersionOnboarding()
      startFlow()
      
    case is AgreementsCoordinator:
      startFlow()
      
    default:
      break
    }
  }
}
