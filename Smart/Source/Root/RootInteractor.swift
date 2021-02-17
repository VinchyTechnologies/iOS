//
//  RootInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Combine
import Core

protocol RootInteractor {
  func startApp()
}

protocol RootDeeplinkable: AnyObject {
  func openTabBar() -> AnyPublisher<TabBarDeeplinkable, Never>
}

final class RootInteractorImpl: RootInteractor, AgreementsViewControllerOutput, OnboardingViewControllerOutput {
  
  func didFinishWathingOnboarding() {
    onboardingRepository.setSawLastVersionOnboarding()
    startApp()
  }
  
  func didConfirmAgeAndAgreement() {
    startApp()
  }
  
  private let router: RootRouter
  private var tabBarDeeplinkable: TabBarDeeplinkable?
  
  private let onboardingRepository = OnboardingRepository(cache: OnboardingCacheImplementation())
  private let publisher = CurrentValueSubject<TabBarDeeplinkable?, Never>(nil)
  init(router: RootRouter) {
    self.router = router
  }
  
  private func startTabBar() {
    publisher.send(router.routeToTabBar())
  }
  
  private func startDoc() {
    router.routeToAgreement(delegate: self)
  }
  
  private func startOnboardingFlow() {
    router.routeToOnboarding(delegate: self)
  }
  
  func startApp() {
    if !(UserDefaultsConfig.isAdult && UserDefaultsConfig.isAgreedToTermsAndConditions) {
      startDoc()
    } else if !onboardingRepository.isLastVersionOnboardingSeen() && isOnboardingAvailable {
      startOnboardingFlow()
    } else {
      startTabBar()
    }
  }
}

extension RootInteractorImpl: RootDeeplinkable {
  func openTabBar() -> AnyPublisher<TabBarDeeplinkable, Never> {
    return publisher
      .compactMap { $0 }
      .eraseToAnyPublisher()
  }
}
