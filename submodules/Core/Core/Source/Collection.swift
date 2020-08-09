//
//  Collection.swift
//  Core
//
//  Created by Aleksei Smirnov on 21.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public enum CollectionType: String, Decodable {
    case mini, big, promo, bottles
}

public struct Collection: Decodable {
    
    public let id: Int
    public let title: String?
    public let type: CollectionType
    public let transition: String
    public let imageURL: String?
    public let wineList: [Wine]

    private enum CodingKeys: String, CodingKey {
        case id = "collection_id"
        case title
        case type = "collection_type"
        case transition = "transition_type"
        case imageURL = "image_url"
        case wineList = "wine_list"
    }
}
