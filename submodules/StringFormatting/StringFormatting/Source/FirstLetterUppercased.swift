//
//  FirstLetterUppercased.swift
//  StringFormatting
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

extension String {
    public func firstLetterUppercased() -> String {

        guard
            let first = first,
            first.isLowercase
        else {
            return self
        }

        return String(first).uppercased() + dropFirst()
    }
}
