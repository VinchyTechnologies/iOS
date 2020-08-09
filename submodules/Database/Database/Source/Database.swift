//
//  Database.swift
//  Database
//
//  Created by Aleksei Smirnov on 20.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import RealmSwift
import Core

func realm(path: RealmType) -> Realm {
    var config = Realm.Configuration()
    config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(path).realm")
    return try! Realm(configuration: config)
}

final class Database<T: Object> {

    func incrementID(object: HasPrimaryKeyID, type: T.Type, path: RealmType) -> Int64 {
        return (realm(path: path).objects(type).max(ofProperty: "id") as Int64? ?? 0) + 1
    }

    func isSaved(object: HasPrimaryKeyID, type: T.Type, at path: RealmType) -> Bool {
        return realm(path: path).object(ofType: type, forPrimaryKey: object.id) != nil
    }

    func isEmpty(type: T.Type, at path: RealmType) -> Bool {
        return !realm(path: path).objects(type).isEmpty
    }

    func all(type: T.Type, at path: RealmType) -> [T] {
        let objs = realm(path: path).objects(type)
        return Array<T>(objs)
    }

    func add(object: HasPrimaryKeyID, type: T.Type, at path: RealmType) {
        try! realm(path: path).write {
            realm(path: path).create(type, value: object, update: .all)
        }
    }

    func remove(object: HasPrimaryKeyID, type: T.Type, at path: RealmType) {
        let deletingObject = realm(path: path).objects(type).filter("id = %@", object.id)
        try! realm(path: path).write {
            realm(path: path).delete(deletingObject)
        }
    }

    func addOrDelete(object: HasPrimaryKeyID, type: T.Type, at path: RealmType) {
        if isSaved(object: object, type: type, at: path) {
            remove(object: object, type: type, at: path)
        } else {
            add(object: object, type: type, at: path)
        }
    }

}
