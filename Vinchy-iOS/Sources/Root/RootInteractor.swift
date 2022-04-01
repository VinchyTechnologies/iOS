//
//  RootInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Combine
import Core

// MARK: - RootInteractor

protocol RootInteractor {
  func startApp()
}

// MARK: - RootDeeplinkable

protocol RootDeeplinkable: AnyObject {
  func openTabBar() -> AnyPublisher<TabBarDeeplinkable, Never>
}

// MARK: - RootInteractorImpl

final class RootInteractorImpl: RootInteractor, AgreementsViewControllerOutput, OnboardingViewControllerOutput {

  // MARK: Lifecycle

  init(router: RootRouter, splashService: SplashService) {
    self.router = router
    self.splashService = splashService
  }

  // MARK: Internal

  func didFinishWathingOnboarding() {
    onboardingRepository.setSawLastVersionOnboarding()
    startApp()
  }

  func didConfirmAgeAndAgreement() {
    startApp()
  }

  func startApp() {
    switch splashService.state {
    case .normal:
      if !(UserDefaultsConfig.isAdult && UserDefaultsConfig.isAgreedToTermsAndConditions) {
        startDoc()
      } else if !onboardingRepository.isLastVersionOnboardingSeen(), isOnboardingAvailable {
        startOnboardingFlow()
      } else {
        startTabBar()
      }

    case .unsupportedVersion:
      startUnavailableVersionFlow()
    }
  }

  // MARK: Private

  private let splashService: SplashService

  private let router: RootRouter
  private var tabBarDeeplinkable: TabBarDeeplinkable?

  private let onboardingRepository = OnboardingRepository(cache: OnboardingCacheImplementation())
  private let publisher = CurrentValueSubject<TabBarDeeplinkable?, Never>(nil)

  private func startUnavailableVersionFlow() {
    router.routeToUnavailableVersionFlow()
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
}

// MARK: RootDeeplinkable

extension RootInteractorImpl: RootDeeplinkable {
  func openTabBar() -> AnyPublisher<TabBarDeeplinkable, Never> {
    publisher
      .compactMap { $0 }
      .eraseToAnyPublisher()
  }
}
