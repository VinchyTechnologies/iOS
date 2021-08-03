//
//  SearchedWinesRepository.swift
//  Database
//
//  Created by Михаил Исаченко on 13.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public let searchedWinesRepository = SearchedWinesRepository() // TODO: - DI

// MARK: - VSearchedWine

public final class VSearchedWine: Codable, DIdentifiable, DSortable, Equatable {

  // MARK: Lifecycle

  public init(id: Int, wineID: Int64, title: String, createdAt: Date) {
    self.id = id
    self.wineID = wineID
    self.title = title
    self.createdAt = createdAt
  }

  // MARK: Public

  public typealias Id = Int // swiftlint:disable:this type_name

  public static var sorting: (VSearchedWine, VSearchedWine) -> Bool {
    { $0.id < $1.id }
  }

  public let id: Int
  public let wineID: Int64
  public let title: String
  public let createdAt: Date

  public static func == (lhs: VSearchedWine, rhs: VSearchedWine) -> Bool {
    lhs.id == rhs.id
  }
}

// MARK: - SearchedWinesRepository

public final class SearchedWinesRepository: CollectionRepository<VSearchedWine> {
  public init() {
    super.init(storage: InMemoryStorageWithFilePersistance().toAny())
  }
}

extension VSearchedWine {
  @objc
  public func value(forKey key: String) -> Any? {
    switch key {
    case "id":
      return id

    case "wineID":
      return wineID

    case "title":
      return title

    case "createdAt":
      return createdAt

    default:
      return nil
    }
  }
}
