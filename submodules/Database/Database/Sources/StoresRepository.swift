//
//  StoresRepository.swift
//  Database
//
//  Created by Алексей Смирнов on 31.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public let storesRepository = StoresRepository() // TODO: - DI

// MARK: - VStore

public final class VStore: Codable, DIdentifiable, DSortable, Equatable {

  // MARK: Lifecycle

  public init(id: Int, affilatedId: Int?, title: String?, subtitle: String?, logoURL: String?) {
    self.id = id
    self.affilatedId = affilatedId
    self.title = title
    self.subtitle = subtitle
    self.logoURL = logoURL
  }

  // MARK: Public

  public typealias Id = Int // swiftlint:disable:this type_name

  public static var sorting: (VStore, VStore) -> Bool {
    { $0.id < $1.id }
  }

  public let id: Int
  public let affilatedId: Int?
  public let title: String?
  public let subtitle: String?
  public let logoURL: String?

  public static func == (lhs: VStore, rhs: VStore) -> Bool {
    lhs.id == rhs.id && lhs.affilatedId == rhs.affilatedId
  }
}

// MARK: - StoresRepository

public final class StoresRepository: CollectionRepository<VStore> {
  public init() {
    super.init(storage: InMemoryStorageWithFilePersistance().toAny())
  }
}

extension VStore {
  @objc
  public func value(forKey key: String) -> Any? {
    switch key {
    case "id":
      return id

    case "affilatedId":
      return affilatedId

    case "title":
      return title

    case "subtitle":
      return subtitle

    case "logoURL":
      return logoURL

    default:
      return nil
    }
  }
}
