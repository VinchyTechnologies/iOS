//
//  Wine.swift
//  Core
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import RealmSwift

public protocol HasPrimaryKeyID: Object {
    dynamic var id: Int64 { get }
    static func myPrimaryKey() -> String
}

extension HasPrimaryKeyID where Self: Object {
    public static func myPrimaryKey() -> String {
        "id"
    }
}

public final class Wine: Object, Decodable, HasPrimaryKeyID {

    @objc public dynamic var id: Int64 = 0
    @objc public dynamic var mainImageUrl: String = ""
    @objc public dynamic var labelImageUrl: String = ""
    public var imageURLs: List<String> = List<String>()
    @objc public dynamic var title: String = ""
    @objc public dynamic var desc: String = ""
    @objc public dynamic var price: Int = 0
    @objc public dynamic var alcoholPercent: Double = 0.0
    @objc public dynamic var servingTemperature: Double = 0.0
    public var dishCompatibility: List<DishCompatibility.RawValue> = List<DishCompatibility.RawValue>()
    @objc public dynamic var year: Int = 0
    public var grapes: List<String> = List<String>()
    public var place: WinePlace = WinePlace(lat: nil, lon: nil, country: nil, region: nil, province: nil)
    public var type: WineType = .none
    public var sugar: Sugar = .none

    public override class func primaryKey() -> String {
        return myPrimaryKey()
    }

    public convenience init(id: Int64, mainImageUrl: String, labelImageUrl: String, imageURLs: [String], title: String, desc: String, price: Int, alcoholPercent: Double, servingTemperature: Double, dishCompatibility: [DishCompatibility], year: Int, grapes: [String], place: WinePlace, type: WineType, sugar: Sugar) {

        self.init()

        self.id = id
        self.mainImageUrl = mainImageUrl
        self.labelImageUrl = labelImageUrl
        imageURLs.forEach { (imageURL) in
            self.imageURLs.append(imageURL)
        }
        self.title = title
        self.desc = desc
        self.price = price
        self.alcoholPercent = alcoholPercent
        self.servingTemperature = servingTemperature
        dishCompatibility.forEach { (dish) in
            self.dishCompatibility.append(dish.rawValue)
        }
        self.year = year
        grapes.forEach { (grape) in
            self.grapes.append(grape)
        }

        self.place = place
        self.type = type
        self.sugar = sugar

    }

    private enum CodingKeys: String, CodingKey {
        case id = "wine_id"
        case title
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
        case place
        case type = "carbon_dioxide"
        case sugar = "sugar"
    }

    convenience required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int64.self, forKey: .id)
        let mainImageURL = (try? container.decodeIfPresent(String.self, forKey: .mainImageURL)) ?? ""
        let labelImageURL = (try? container.decodeIfPresent(String.self, forKey: .labelImageUrl)) ?? ""
        let imageURLs = (try? container.decodeIfPresent([String].self, forKey: .imageURLs)) ?? []
        let title = (try? container.decodeIfPresent(String.self, forKey: .title)) ?? ""
        let desc = (try? container.decodeIfPresent(String.self, forKey: .desc)) ?? ""
        let price = (try? container.decodeIfPresent(Int.self, forKey: .price)) ?? 0
        let alcoholPercent = (try? container.decodeIfPresent(Double.self, forKey: .alcoholPercent)) ?? 0.0
        let servingTemperature = (try? container.decodeIfPresent(Double.self, forKey: .servingTemperature)) ?? 0.0
        let dishCompatibility = (try? container.decodeIfPresent([DishCompatibility].self, forKey: .dishCompatibility)) ?? []
        let year = (try? container.decodeIfPresent(Int.self, forKey: .year)) ?? 0
        let grapes = (try? container.decodeIfPresent([String].self, forKey: .grapes)) ?? []
        let place = (try? container.decodeIfPresent(WinePlace.self, forKey: .place)) ?? WinePlace(lat: nil, lon: nil, country: nil, region: nil, province: nil)
        let type = (try? container.decodeIfPresent(WineType.self, forKey: .type)) ?? .none
        let sugar = (try? container.decodeIfPresent(Sugar.self, forKey: .sugar)) ?? .none

        self.init(id: id, mainImageUrl: mainImageURL, labelImageUrl: labelImageURL, imageURLs: imageURLs, title: title, desc: desc, price: price, alcoholPercent: alcoholPercent, servingTemperature: servingTemperature, dishCompatibility: dishCompatibility, year: year, grapes: grapes, place: place, type: type, sugar: sugar)
    }
}

public enum WineType: String, Decodable {
    case sparkling, quiet, none
}
