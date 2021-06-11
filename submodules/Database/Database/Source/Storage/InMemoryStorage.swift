//
//  InMemoryStorage.swift
//  DataPersistence
//
//  Created by Mikhail Rubanov on 25.09.2020.
//

import Foundation

public final class InMemoryStorage<M>: StorageProtocol {
    public init(model: M? = nil) {
        self.model = model
    }

    public func read() -> M? {
        model
    }

    public func save(_ model: M) {
        self.model = model
    }

    public func clear() {
        model = nil
    }

    private var model: M?
}
