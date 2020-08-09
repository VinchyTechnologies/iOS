//
//  UserDefaults.swift
//  Core
//
//  Created by Aleksei Smirnov on 01.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

struct UserDefaultsConfig {
    @UserDefault("isAdult", defaultValue: false)
    static var isAdult: Bool
}


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
