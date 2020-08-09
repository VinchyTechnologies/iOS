//
//  Localized.swift
//  StringFormatting
//
//  Created by Aleksei Smirnov on 19.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public func localized(_ string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
