//
//  Collection.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display

public enum CollectionType: String, Decodable {
    case mini, big, promo, bottles

    public var itemSize: VinchySize {
        switch self {
        case .mini:
            return .init(width: .absolute(135), height: .absolute(135))
        case .big:
            return .init(width: .dimension(2/3), height: .absolute(155))
        case .promo:
            return .init(width: .dimension(5/6), height: .absolute(120))
        case .bottles:
            return .init(width: .absolute(150), height: .absolute(250))
        }
    }
}

public struct Collection: Decodable {

    public let id: Int
    public let title: String?
    public let type: CollectionType
    public let imageURL: String?
    public let wineList: [Wine]

    private enum CodingKeys: String, CodingKey {
        case id = "collection_id"
        case title
        case type = "collection_type"
        case imageURL = "image_url"
        case wineList = "wine_list"
    }
}
