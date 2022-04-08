//
//  Wine.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

// MARK: - Wine

public struct Wine: Decodable {

  // MARK: Lifecycle

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
    let maxServingTemperature = try? container.decodeIfPresent(Double.self, forKey: .maxServingTemperature)
    let minServingTemperature = try? container.decodeIfPresent(Double.self, forKey: .minServingTemperature)
    let dishCompatibilityFromBackend = try? container.decodeIfPresent([DishCompatibility].self, forKey: .dishCompatibility)

    var dishCompatibility: [DishCompatibility] = []

    if let dishCompatibilityFromBackend = dishCompatibilityFromBackend, !dishCompatibilityFromBackend.isEmpty {
      var orderedAllCases = DishCompatibility.allCases
      orderedAllCases.forEach { dish in
        if !dishCompatibilityFromBackend.contains(dish) {
          orderedAllCases.removeAll(where: { $0 == dish })
        }
      }
      dishCompatibility = orderedAllCases
    }

    let year = try? container.decodeIfPresent(Int.self, forKey: .year)
    let grapes = try? container.decodeIfPresent([String].self, forKey: .grapes)
    let winery = try? container.decodeIfPresent(Winery.self, forKey: .winery)
    let type = try? container.decodeIfPresent(WineType.self, forKey: .type)
    let sugar = try? container.decodeIfPresent(Sugar.self, forKey: .sugar)
    let similarWines = try? container.decodeIfPresent([ShortWine].self, forKey: .similarWines)
    let rating = try? container.decodeIfPresent(Double.self, forKey: .rating)
    let volume = try? container.decodeIfPresent(Float.self, forKey: .volume)

    self.id = id
    self.color = color
    mainImageUrl = mainImageURL
    labelImageUrl = labelImageURL
    self.imageURLs = imageURLs
    self.title = title
    self.desc = desc
    self.price = price
    self.alcoholPercent = alcoholPercent
    self.maxServingTemperature = maxServingTemperature
    self.minServingTemperature = minServingTemperature
    self.dishCompatibility = dishCompatibility
    self.year = year
    self.grapes = grapes
    self.winery = winery
    self.type = type
    self.sugar = sugar
    self.similarWines = similarWines
    self.rating = rating
    self.volume = volume
  }

  /// For test only
  /*
   public init(title: String, imageURL: String?, winery: Winery) {
     self.id = 0
     self.color = nil
     self.mainImageUrl = imageURL
     self.labelImageUrl = nil
     self.imageURLs = nil
     self.title = title
     self.desc = nil
     self.price = nil
     self.alcoholPercent = nil
     self.servingTemperature = nil
     self.dishCompatibility = nil
     self.year = nil
     self.grapes = nil
     self.winery = winery
     self.type = nil
     self.sugar = nil
   }
   */

  // MARK: Public

  /// Wine ID
  public let id: Int64

  /// Name of the wine
  public let title: String

  /// Color of the wiine
  public let color: WineColor?
  public let mainImageUrl: String?
  public let labelImageUrl: String?
  public let imageURLs: [String]?
  public let desc: String?
  public let price: Int64?
  public let alcoholPercent: Double?
  public let maxServingTemperature: Double?
  public let minServingTemperature: Double?
  public let dishCompatibility: [DishCompatibility]?
  public let year: Int?
  public let grapes: [String]?
  public let winery: Winery?
  public let type: WineType?
  public let sugar: Sugar?
  public let similarWines: [ShortWine]?
  public let rating: Double?
  public let volume: Float?

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case id = "wine_id"
    case title
    case color
    case mainImageURL = "bottle_image_url"
    case labelImageUrl = "label_image_url"
    case imageURLs = "image_url_list"
    case price
    case alcoholPercent = "alcohol_percent"
    case maxServingTemperature = "max_serving_temperature"
    case minServingTemperature = "min_serving_temperature"
    case desc = "description"
    case dishCompatibility = "dish_list"
    case year
    case grapes = "grape_list"
    case winery
    case type = "carbon_dioxide"
    case sugar
    case similarWines = "similar_wines"
    case reviews
    case rating
    case volume
  }
}

// MARK: - WineType

public enum WineType: String, Decodable {
  case sparkling, quiet
}

// MARK: - WineColor

public enum WineColor: String, Decodable {
  case red, white, pink
}
