//
//  Wine.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public struct Wine: Decodable {

    public let id: Int64
    public let title: String
    public let color: WineColor?
    public let mainImageUrl: String?
    public let labelImageUrl: String?
    public let imageURLs: [String]?
    public let desc: String?
    public let price: Int64?
    public let alcoholPercent: Double?
    public let servingTemperature: Double?
    public let dishCompatibility: [DishCompatibility]?
    public let year: Int?
    public let grapes: [String]?
    public let winery: Winery?
    public let type: WineType?
    public let sugar: Sugar?

    private enum CodingKeys: String, CodingKey {
        case id = "wine_id"
        case title
        case color
        case mainImageURL = "bottle_image_url"
        case labelImageUrl = "label_image_url"
        case imageURLs = "image_url_list"
        case price
        case alcoholPercent = "alcohol_percent"
        case servingTemperature = "serving_temperature"
        case desc = "description"
        case dishCompatibility = "dish_list"
        case year = "year"
        case grapes = "grape_list"
        case winery
        case type = "carbon_dioxide"
        case sugar = "sugar"
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int64.self, forKey: .id)
        let color = try? container.decodeIfPresent(WineColor.self, forKey: .color)
        let mainImageURL = try? container.decodeIfPresent(String.self, forKey: .mainImageURL)
        let labelImageURL = try? container.decodeIfPresent(String.self, forKey: .labelImageUrl)
        let imageURLs = try? container.decodeIfPresent([String].self, forKey: .imageURLs)
        let title = try container.decode(String.self, forKey: .title)
        let desc = try? container.decodeIfPresent(String.self, forKey: .desc)
        let price = try? container.decodeIfPresent(Int64.self, forKey: .price)
        let alcoholPercent = try? container.decodeIfPresent(Double.self, forKey: .alcoholPercent)
        let servingTemperature = try? container.decodeIfPresent(Double.self, forKey: .servingTemperature)
        let dishCompatibility = try? container.decodeIfPresent([DishCompatibility].self, forKey: .dishCompatibility)
        let year = try? container.decodeIfPresent(Int.self, forKey: .year)
        let grapes = try? container.decodeIfPresent([String].self, forKey: .grapes)
        let winery = try? container.decodeIfPresent(Winery.self, forKey: .winery)
        let type = try? container.decodeIfPresent(WineType.self, forKey: .type)
        let sugar = try? container.decodeIfPresent(Sugar.self, forKey: .sugar)

        self.id = id
        self.color = color
        self.mainImageUrl = mainImageURL
        self.labelImageUrl = labelImageURL
        self.imageURLs = imageURLs
        self.title = title
        self.desc = desc
        self.price = price
        self.alcoholPercent = alcoholPercent
        self.servingTemperature = servingTemperature
        self.dishCompatibility = dishCompatibility
        self.year = year
        self.grapes = grapes
        self.winery = winery
        self.type = type
        self.sugar = sugar
    }
}

public enum WineType: String, Decodable {
    case sparkling, quiet, none
}

public enum WineColor: String, Decodable { // TODO: - localize
    case red, white, pink
}
