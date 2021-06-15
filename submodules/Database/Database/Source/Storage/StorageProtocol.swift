//
//  StorageProtocol.swift
//  DataPersistence
//
//  Created by Mikhail Rubanov on 25.09.2020.
//

import Foundation

// MARK: - StorageProtocol

// Hides impl
public protocol StorageProtocol {
  associatedtype M

  func read() -> M?
  func save(_ model: M)
  func clear()
}

extension StorageProtocol {
  public func toAny<M>() -> AnyStorage<M> where M == Self.M {
    AnyStorage(self)
  }
}
