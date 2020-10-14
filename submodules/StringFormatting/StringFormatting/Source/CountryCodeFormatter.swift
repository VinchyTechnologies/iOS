//
//  CountryCodeFormatter.swift
//  StringFormatting
//
//  Created by Aleksei Smirnov on 04.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public func countryNameFromLocaleCode(countryCode: String?) -> String? {

    guard let countryCode = countryCode else {
        return nil
    }

    if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
        return name
    }
    
    return nil
}
