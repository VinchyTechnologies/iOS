//
//  Compilation.swift
//  Core
//
//  Created by Aleksei Smirnov on 27.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public struct Compilation: Decodable {
    public let id: Int64
    public let title: String?
    public let collectionList: [Collection]

    private enum CodingKeys: String, CodingKey {
        case id = "compilation_id"
        case title
        case collectionList = "collection_list"
    }
}
