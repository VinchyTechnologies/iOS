//
//  ShortWine.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 08.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public struct ShortWine: Decodable, Equatable {

  // MARK: Lifecycle

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let id = try container.decode(Int64.self, forKey: .id)
    let mainImageURL = try? container.decodeIfPresent(String.self, forKey: .mainImageURL)
    let title = try container.decode(String.self, forKey: .title)
    let winery = try? container.decodeIfPresent(Winery.self, forKey: .winery)
    let rating = try? container.decodeIfPresent(Double.self, forKey: .rating)
    let url = try? container.decodeIfPresent(String.self, forKey: .url)
    let price = try? container.decodeIfPresent(Price.self, forKey: .price)
    let oldPrice = try? container.decodeIfPresent(Price.self, forKey: .oldPrice)
    let discountText = try? container.decodeIfPresent(String.self, forKey: .discountText)

    self.id = id
    mainImageUrl = mainImageURL
    self.title = title
    self.winery = winery
    self.rating = rating
    self.url = url
    self.price = price
    self.oldPrice = oldPrice
    self.discountText = discountText
  }

  // MARK: Public

  #if DEBUG
  public static var fake: ShortWine {
    let json = """
    {
        "wine_id":67307,
        "title":"Colheita Malmsey Madeira (Single Harvest)",
        "bottle_image_url":"https://bucket.vinchy.tech/wines/67307.png",
        "winery":{
           "winery_id":8883,
           "title":"Blandy's",
           "country_code":"PT",
           "region":"Madeira"
        },
        "rating":null
     }
    """
    let jsonData = Data(json.utf8)
    let decoder = JSONDecoder()
    let obj = try! decoder.decode(ShortWine.self, from: jsonData) // swiftlint:disable:this force_try
    return obj
  }
  #endif

  public let id: Int64

  public let title: String

  public let mainImageUrl: String?

  public let winery: Winery?

  public let rating: Double?

  public let url: String?

  public let price: Price?

  public let oldPrice: Price?

  public let discountText: String?

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case id = "wine_id"
    case title
    case mainImageURL = "bottle_image_url"
    case winery
    case rating
    case url
    case price
    case oldPrice = "old_price"
    case discountText = "discount_text"
  }
}
