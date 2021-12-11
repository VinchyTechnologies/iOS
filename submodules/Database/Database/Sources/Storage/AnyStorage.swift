//
//  AnyStorage.swift
//  DataPersistence
//
//  Created by Mikhail Rubanov on 25.09.2020.
//

import Foundation

// MARK: - AbstractStorage

private class AbstractStorage<M>: StorageProtocol {
  func read() -> M? {
    fatalError("abstract needs override")
  }

  func save(_: M) {
    fatalError("abstract needs override")
  }

  func clear() {
    fatalError("abstract needs override")
  }
}

// MARK: - StorageBox

private final class StorageBox<T: StorageProtocol>: AbstractStorage<T.M> {

  // MARK: Lifecycle

  init(_ concrete: T) {
    self.concrete = concrete
  }

  // MARK: Internal

  override func read() -> M? {
    concrete.read()
  }

  override func save(_ model: M) {
    concrete.save(model)
  }

  override func clear() {
    concrete.clear()
  }

  // MARK: Private

  private var concrete: T
}

// MARK: - AnyStorage

public final class AnyStorage<M>: StorageProtocol {

  // MARK: Lifecycle

  internal init<K: StorageProtocol>(_ provider: K) where K.M == M {
    box = StorageBox(provider)
  }

  // MARK: Public

  // MARK: - StorageProtocol

  public func read() -> M? {
    box.read()
  }

  public func save(_ model: M) {
    box.save(model)
  }

  public func clear() {
    box.clear()
  }

  // MARK: Private

  private let box: AbstractStorage<M>
}
