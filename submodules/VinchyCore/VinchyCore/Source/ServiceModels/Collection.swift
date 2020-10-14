//
//  Collection.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display // TODO: - Delete
import UIKit

public protocol AdsProtocol: AnyObject { }

public enum CollectionType: String, Decodable {

    case mini, big, promo, bottles, shareUs, infinity, smartFilter

    public var itemSize: VinchySize {
        switch self {
        case .mini:
            return .init(width: .absolute(135), height: .absolute(135))

        case .big:
            return .init(width: .dimension(2 / 3), height: .absolute(155))

        case .promo:
            return .init(width: .dimension(5 / 6), height: .absolute(120))

        case .bottles:
            return .init(width: .absolute(150), height: .absolute(250))

        case .shareUs:
            return .init(width: .dimension(1), height: .absolute(160))

        case .infinity:
            return .init(width: .dimension(2), height: .absolute(250))
            
        case .smartFilter:
            return .init(width: .absolute(UIScreen.main.bounds.width - 40), height: .absolute(250))
        }
    }
}

public enum CollectionItem {
    case wine(wine: Wine)
    case ads(ad: AdsProtocol)
}

public struct Collection: Decodable {

    public let id: Int64?
    public let title: String?
    public let imageURL: String?
    public var wineList: [CollectionItem]

    private enum CodingKeys: String, CodingKey {
        case id = "collection_id"
        case title
        case imageURL = "image_url"
        case wineList = "wine_list"
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int64.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        let wineList = try? container.decode([Wine].self, forKey: .wineList)

        let wines = wineList?.compactMap({ (wine) -> CollectionItem in
            return .wine(wine: wine)
        })

        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.wineList = wines ?? []

    }

    public init(wineList: [CollectionItem]) {
        self.id = nil
        self.title = nil
        self.imageURL = nil
        self.wineList = wineList
    }
}
