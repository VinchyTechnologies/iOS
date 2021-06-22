//
//  WinesRepository.swift
//  Database
//
//  Created by Алексей Смирнов on 12.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public let winesRepository = WinesRepository() // TODO: - DI

public func imageURL(from wineID: Int64) -> String {
  "https://bucket.vinchy.tech/wines/" + String(wineID) + ".png"
}

// MARK: - VWine

public final class VWine: Codable, DIdentifiable, DSortable, Equatable {

  // MARK: Lifecycle

  public init(id: Int, wineID: Int64?, title: String?, isLiked: Bool?, isDisliked: Bool?) {
    self.id = id
    self.wineID = wineID
    self.title = title
    self.isLiked = isLiked
    self.isDisliked = isDisliked
  }

  // MARK: Public

  public typealias Id = Int // swiftlint:disable:this type_name

  public static var sorting: (VWine, VWine) -> Bool {
    { $0.id < $1.id }
  }

  public let id: Int
  public let wineID: Int64?
  public let title: String?
  public let isLiked: Bool?
  public let isDisliked: Bool?

  public static func == (lhs: VWine, rhs: VWine) -> Bool {
    lhs.id == rhs.id
  }
}

// MARK: - WinesRepository

public final class WinesRepository: CollectionRepository<VWine> {
  public init() {
    super.init(storage: InMemoryStorageWithFilePersistance().toAny())
  }
}

extension VWine {
  @objc
  public func value(forKey key: String) -> Any? {
    switch key {
    case "id":
      return id

    case "wineID":
      return wineID

    case "title":
      return title

    case "isLiked":
      return isLiked

    case "isDisliked":
      return isDisliked

    default:
      return nil
    }
  }
}
