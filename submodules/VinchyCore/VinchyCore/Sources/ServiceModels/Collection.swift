//
//  Collection.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - CollectionType

public enum CollectionType: String, Decodable {
  case mini, big, promo, bottles, shareUs, smartFilter, partnerBottles
}

// MARK: - Collection

public struct Collection: Decodable {

  // MARK: Lifecycle

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let id = try container.decode(Int.self, forKey: .id)
    let title = try container.decode(String.self, forKey: .title)
    let imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
    let wineList = try? container.decode([ShortWine].self, forKey: .wineList)

    self.id = id
    self.title = title
    self.imageURL = imageURL
    self.wineList = wineList ?? []
  }

  public init(wineList: [ShortWine]) {
    id = nil
    title = nil
    imageURL = nil
    self.wineList = wineList
  }

  public init(title: String?, imageURL: String) {
    id = nil
    self.title = title
    self.imageURL = imageURL
    wineList = []
  }

  // MARK: Public

  public let id: Int?
  public let title: String?
  public let imageURL: String?
  public var wineList: [ShortWine]

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case id = "collection_id"
    case title
    case imageURL = "image_url"
    case wineList = "wine_list"
  }
}
