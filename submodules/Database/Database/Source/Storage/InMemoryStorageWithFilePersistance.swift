//
//  InMemoryStorageWithFilePersistance.swift
//  DataPersistence
//
//  Created by Mikhail Rubanov on 25.09.2020.
//

import Foundation

public final class InMemoryStorageWithFilePersistance<M: Codable>: StorageProtocol {
    public func read() -> M? {
        if let inMemoryModel = inMemoryStorage.read() {
            return inMemoryModel
        }
        if let inFileModel = fileStorage.read() {
            inMemoryStorage.save(inFileModel)
            return inFileModel
        }

        return nil
    }

    public func save(_ model: M) {
        inMemoryStorage.save(model)
        fileStorage.save(model)
    }

    public func clear() {
        inMemoryStorage.clear()
        fileStorage.clear()
    }

    public init() {}

    private let fileStorage: FileStorage<M> = FileStorage()
    private let inMemoryStorage: InMemoryStorage<M> = InMemoryStorage()
}
