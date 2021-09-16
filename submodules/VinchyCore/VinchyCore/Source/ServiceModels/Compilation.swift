//
//  Compilation.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public struct Compilation: Decodable {

  // MARK: Lifecycle

  public init(id: Int? = nil, type: CollectionType, imageURL: String?, title: String?, collectionList: [Collection]) {
    self.id = id
    self.type = type
    self.title = title
    self.collectionList = collectionList
    self.imageURL = imageURL
  }

  // MARK: Public

  public let id: Int?
  public let type: CollectionType
  public let title: String?
  public let imageURL: String?
  public var collectionList: [Collection]

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case id = "compilation_id"
    case type = "compilation_type"
    case title
    case collectionList = "collection_list"
    case imageURL
  }

}
