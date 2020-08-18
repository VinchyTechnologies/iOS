//
//  Filter.swift
//  Core
//
//  Created by Aleksei Smirnov on 20.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation
import StringFormatting

public enum FilterType: String, Decodable {
    case carusel
}

public struct Filter: Decodable {
    public let title: String
    public let type: FilterType
    public let items: [FilterItem]
}

public struct FilterItem: Decodable {
    public let title: String
    public let imageName: String?
}

public func loadFilters() -> [Filter] {
    
    guard let filePath = Bundle.main.path(forResource: "filters", ofType: "json") else {
        return []
    }

    guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
        return []
    }

    return try! JSONDecoder().decode([Filter].self, from: data)
}
