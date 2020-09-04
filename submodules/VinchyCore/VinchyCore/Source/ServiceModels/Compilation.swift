//
//  Compilation.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public struct Compilation: Decodable {
    public let id: Int64?
    public let title: String?
    public var collectionList: [Collection]

    private enum CodingKeys: String, CodingKey {
        case id = "compilation_id"
        case title
        case collectionList = "collection_list"
    }

    public init(title: String?, collectionList: [Collection]) {
        self.id = nil
        self.title = title
        self.collectionList = collectionList
    }
}
