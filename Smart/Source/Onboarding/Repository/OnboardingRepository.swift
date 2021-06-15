//
//  OnboardingRepository.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

// MARK: - OnboardingRepositoryProtocol

public protocol OnboardingRepositoryProtocol {
  func setSawLastVersionOnboarding()
  func isLastVersionOnboardingSeen() -> Bool
}

// MARK: - OnboardingRepository

public final class OnboardingRepository: OnboardingRepositoryProtocol {

  // MARK: Lifecycle

  // MARK: - Initializers

  public init(cache: OnboardingCache) {
    self.cache = cache
  }

  // MARK: Public

  // MARK: - Public Methods

  public func setSawLastVersionOnboarding() {
    cache.updateCache(with: C.onboardingVersion)
  }

  public func isLastVersionOnboardingSeen() -> Bool {
    guard
      let lastSeenOnboardingVersion = cache.getLastSawOnboardingVersion(),
      lastSeenOnboardingVersion == C.onboardingVersion
    else {
      return false
    }

    return true
  }

  // MARK: Private

  // MARK: - Private Properties

  private enum C {
    static let onboardingVersion: Int = 1
  }

  private let cache: OnboardingCache
}
