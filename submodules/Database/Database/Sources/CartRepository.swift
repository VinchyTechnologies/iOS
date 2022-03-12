//
//  CartRepository.swift
//  Database
//
//  Created by Алексей Смирнов on 08.03.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

public let cartRepository = CartRepository() // TODO: - DI

// MARK: - VCartItem

public final class VCartItem: Codable, DIdentifiable, DSortable, Equatable {

  // MARK: Lifecycle

  public init(id: Int, affilatedId: Int?, productId: Int64?, kind: Kind?, quantity: Int?) {
    self.id = id
    self.affilatedId = affilatedId
    self.productId = productId
    self.kind = kind
    self.quantity = quantity
  }

  // MARK: Public

  public enum Kind: String, Codable {
    case wine
  }

  public typealias Id = Int // swiftlint:disable:this type_name

  public static var sorting: (VCartItem, VCartItem) -> Bool {
    { $0.id < $1.id }
  }

  public let id: Int
  public let affilatedId: Int?
  public let productId: Int64?
  public let quantity: Int?
  public let kind: Kind?

  public static func == (lhs: VCartItem, rhs: VCartItem) -> Bool {
    lhs.id == rhs.id && lhs.affilatedId == rhs.affilatedId && lhs.productId == rhs.productId && lhs.kind == rhs.kind
  }
}

// MARK: - CartRepository

public final class CartRepository: CollectionRepository<VCartItem> {
  public init() {
    super.init(storage: InMemoryStorageWithFilePersistance().toAny())
  }
}

extension VCartItem {
  @objc
  public func value(forKey key: String) -> Any? {
    switch key {
    case "id":
      return id

    case "affilatedId":
      return affilatedId

    case "productId":
      return productId

    case "quantity":
      return quantity

    case "kind":
      return kind

    default:
      return nil
    }
  }
}

// MARK: - CartItem

public final class CartItem: Decodable {

  // MARK: Lifecycle

  public init(productID: Int64, type: Kind, count: Int) {
    self.productID = productID
    self.type = type
    self.count = count
  }

  // MARK: Public

  public enum Kind: Decodable {
    case wine
  }

  public let productID: Int64
  public let type: Kind
  public var count: Int
}
