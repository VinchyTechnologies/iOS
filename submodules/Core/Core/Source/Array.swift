//
//  Array.swift
//  Core
//
//  Created by Aleksei Smirnov on 28.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public extension Array {
    func grouped<T: Hashable>(map: ((Element) -> (T))) -> [[Element]] {
        let dict = Dictionary(grouping: self) { map($0) }
        return dict.values.map { Array<Element>($0) }
    }
}
