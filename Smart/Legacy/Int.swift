//
//  Int.swift
//  ASUI
//
//  Created by Aleksei Smirnov on 18.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

extension Int {

    public func toPrice() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.currencySymbol = "₽"
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.groupingSeparator = "."

        if let number = numberFormatter.string(from: NSNumber(value: self)) {
            return number + " ₽"
        }

        return ""
    }

}
