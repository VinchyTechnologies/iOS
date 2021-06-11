//
//  StorageProtocol.swift
//  DataPersistence
//
//  Created by Mikhail Rubanov on 25.09.2020.
//

import Foundation

// Hides impl
public protocol StorageProtocol {
    associatedtype M

    func read() -> M?
    func save(_ model: M)
    func clear()
}

public extension StorageProtocol {
    func toAny<M>() -> AnyStorage<M> where M == Self.M {
        AnyStorage(self)
    }
}
