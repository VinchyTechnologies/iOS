//
//  CollectionExt.swift
//  Core
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public extension Swift.Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        guard index >= startIndex, endIndex > index else { return nil }
        return self[index]
    }
}
