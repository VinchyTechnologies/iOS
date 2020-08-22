//
//  Collection.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public enum CollectionType: String, Decodable {
    case mini, big, promo, bottles
}

public struct Collection: Decodable {

    public let id: Int
    public let title: String?
    public let type: CollectionType
    public let transition: CollectionTransitionType
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

public enum CollectionTransitionType: String, Decodable {
    case detailCollection = "detail_collection"
    case detailWine = "detail_wine"
}
