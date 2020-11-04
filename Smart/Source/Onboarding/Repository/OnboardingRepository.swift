//
//  OnboardingRepository.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public protocol OnboardingRepositoryProtocol {
  func setSawLastVersionOnboarding()
  func isLastVersionOnboardingSeen() -> Bool
}

final public class OnboardingRepository: OnboardingRepositoryProtocol {
  
  // MARK: - Private Properties
  
  private enum C {
    static let onboardingVersion: Int = 1
  }
  
  private let cache: OnboardingCache
  
  // MARK: - Initializers
  
  public init(cache: OnboardingCache) {
    self.cache = cache
  }
  
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
}
