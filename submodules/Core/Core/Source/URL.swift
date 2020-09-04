//
//  URL.swift
//  Core
//
//  Created by Aleksei Smirnov on 04.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public extension String {

    var toURL: URL? {

        if self == "" {
            return nil
        }

        return URL(string: self)
    }
}

extension Optional where Wrapped == String {
    var toURL: URL? {

        if self == nil || self == "" {
            return nil
        }

        return URL(string: self!)
    }
}
