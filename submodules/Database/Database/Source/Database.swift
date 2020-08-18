//
//  Database.swift
//  Database
//
//  Created by Aleksei Smirnov on 20.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import RealmSwift
import Core

public func realm(path: RealmType) -> Realm {
    var config = Realm.Configuration()
    config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(path).realm")
    return try! Realm(configuration: config)
}

public final class Database<T: Object> {

    public init() { }

    public func incrementID(path: RealmType) -> Int64 {
        return (realm(path: path).objects(T.self).max(ofProperty: "id") as Int64? ?? 0) + 1
    }

    public func isSaved(object: HasPrimaryKeyID, at path: RealmType) -> Bool {
        return realm(path: path).object(ofType: T.self, forPrimaryKey: object.id) != nil
    }

    public func isEmpty(at path: RealmType) -> Bool {
        return !realm(path: path).objects(T.self).isEmpty
    }

    public func all(at path: RealmType) -> [T] {
        let objs = realm(path: path).objects(T.self)
        return Array<T>(objs)
    }

    public func add(object: HasPrimaryKeyID, at path: RealmType) {
        try! realm(path: path).write {
            realm(path: path).add(object, update: .all)
        }
    }

    public func remove(object: HasPrimaryKeyID, at path: RealmType) {
        let deletingObject = realm(path: path).objects(T.self).filter("id = %@", object.id)
        try! realm(path: path).write {
            realm(path: path).delete(deletingObject)
        }
    }

    public func addOrRemove(object: HasPrimaryKeyID, at path: RealmType) {
        if isSaved(object: object, at: path) {
            remove(object: object, at: path)
        } else {
            add(object: object, at: path)
        }
    }

}
