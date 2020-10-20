//
//  OnboardingCache.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core

public protocol OnboardingCache {

    /// Обновить кеш онбординга
    ///
    /// - Parameter lastSeenOnboardingVersion: последняя версия онбординга
    func updateCache(with lastSeenOnboardingVersion: Int)

    /// Получить закешированную последнюю увиденную версию онбординга
    func getLastSawOnboardingVersion() -> Int?
}

final class OnboardingCacheImplementation: OnboardingCache {

    func updateCache(with lastSeenOnboardingVersion: Int) {
        UserDefaultsConfig.lastSeenOnboardingVersion = lastSeenOnboardingVersion
    }

    func getLastSawOnboardingVersion() -> Int? {
        if UserDefaultsConfig.lastSeenOnboardingVersion == 0 {
            return nil
        }
        return UserDefaultsConfig.lastSeenOnboardingVersion
    }
}
