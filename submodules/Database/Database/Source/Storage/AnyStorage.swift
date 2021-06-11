//
//  AnyStorage.swift
//  DataPersistence
//
//  Created by Mikhail Rubanov on 25.09.2020.
//

import Foundation

private class AbstractStorage<M>: StorageProtocol {
    func read() -> M? {
        fatalError("abstract needs override")
    }
    func save(_ model: M) {
        fatalError("abstract needs override")
    }
    func clear() {
        fatalError("abstract needs override")
    }
}


private final class StorageBox<T: StorageProtocol>: AbstractStorage<T.M> {
    private var concrete: T

    init(_ concrete: T) {
        self.concrete = concrete
    }

    override func read() -> M? {
        concrete.read()
    }
    override func save(_ model: M) {
        concrete.save(model)
    }
    override func clear() {
        concrete.clear()
    }
}

public final class AnyStorage<M>: StorageProtocol {
    private let box: AbstractStorage<M>

    internal init<K: StorageProtocol>(_ provider: K) where K.M == M {
        self.box = StorageBox(provider)
    }

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
}
