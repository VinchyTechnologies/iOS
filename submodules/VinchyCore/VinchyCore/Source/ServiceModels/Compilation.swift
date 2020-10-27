//
//  Compilation.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public struct Compilation: Decodable {

  public let id: Int64?
  public let type: CollectionType
  public let title: String?
  public var collectionList: [Collection]

  private enum CodingKeys: String, CodingKey {
    case id = "compilation_id"
    case type = "compilation_type"
    case title
    case collectionList = "collection_list"
  }

  public init(type: CollectionType, title: String?, collectionList: [Collection]) {
    self.id = nil
    self.type = type
    self.title = title
    self.collectionList = collectionList
  }
}
