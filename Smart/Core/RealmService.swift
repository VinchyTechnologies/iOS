//
//  RealmService.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 15.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import RealmSwift
import Core

protocol RealmProductProtocol {
//    func isFafourite(product: Wine) -> Bool
//    func toOrUnFafourite(product: Wine)
//    func save(product: Wine)
//    func delete(product: Wine)
//    func allFavourites() -> [Wine]
//    func hasFavourites() -> Bool
//    func allCartItems() -> [CartItem]
//    func cartIsEmpty() -> Bool
//    func isIntheCart(product: Wine) -> Bool
//    func saveToCart(product: Wine)
//    func deleteFromCart(product: Wine)
//    func totalSum() -> Int
//    func allAddresses() -> [Address]
//    func hasAddress() -> Bool
//    func saveAddress(address: Address)
//    func deleteAddress(address: Address)
}

//extension RealmProductProtocol {
//
//    func isIntheCart(product: Wine) -> Bool {
//        let realm = try! Realm()
//        return realm.object(ofType: CartItem.self, forPrimaryKey: product.id) != nil
//    }
//
//    func saveToCart(product: Wine) {
//        let realm = try! Realm()
//        if isIntheCart(product: product) {
//            try! realm.write {
//                let obj = realm.object(ofType: CartItem.self, forPrimaryKey: product.id)
//                obj?.number += 1
//            }
//        } else {
//            let savingCartItem = CartItem()
//            savingCartItem.id = product.id
//            savingCartItem.product = product
//            savingCartItem.number = 1
//            try! realm.write {
//                realm.create(CartItem.self, value: savingCartItem, update: .all)
//            }
//        }
//    }
//
//    func deleteFromCart(product: Wine) {
//        let realm = try! Realm()
//        if isIntheCart(product: product) {
//            try! realm.write {
//                if let cartItem = realm.object(ofType: CartItem.self, forPrimaryKey: product.id) {
//                    if cartItem.number - 1 <= 0 {
//                        let deletingItem = realm.objects(CartItem.self).filter("id = %@", product.id)
//                        realm.delete(deletingItem)
//                    } else {
//                        cartItem.number -= 1
//                    }
//                }
//            }
//        }
//    }
//
//    func totalSum() -> Int {
//        let realm = try! Realm()
//        var sum = 0
//        if cartIsEmpty() {
//            return 0
//        }
//
//        for obj in realm.objects(CartItem.self) {
//            sum += obj.number * obj.product.price
//        }
//
//        return sum
//    }
//
//    func cartIsEmpty() -> Bool {
//        let realm = try! Realm()
//        return realm.objects(CartItem.self).isEmpty
//    }
//
//    func allCartItems() -> [CartItem] {
//        let realm = try! Realm()
//        let objs = realm.objects(CartItem.self)
//        return Array<CartItem>(objs)
//    }
//
//    func allAddresses() -> [Address] {
//        var config = Realm.Configuration()
//        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\("username").realm") // TODO: - userNameOrID
//        let realm = try! Realm(configuration: config)
//
//        let objs = realm.objects(Address.self)
//        return Array<Address>(objs)
//    }
//
//    func hasAddress() -> Bool {
//        var config = Realm.Configuration()
//        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\("username").realm") // TODO: - userNameOrID
//        let realm = try! Realm(configuration: config)
//        return !realm.objects(Address.self).isEmpty
//    }
//
//    func saveAddress(address: Address) {
//        var config = Realm.Configuration()
//        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\("username").realm") // TODO: - userNameOrID
//        let realm = try! Realm(configuration: config)
//
//        let savingAddress = Address()
//        savingAddress.id = address.id
//        savingAddress.fullName = address.fullName
//        savingAddress.lat = address.lat
//        savingAddress.lon = address.lon
//
//        try! realm.write {
//            realm.create(Address.self, value: savingAddress, update: .all)
//        }
//    }
//
//    func deleteAddress(address: Address) {
//        var config = Realm.Configuration()
//        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\("username").realm") // TODO: - userNameOrID
//        let realm = try! Realm(configuration: config)
//
//        let deletingAddress = realm.objects(Address.self).filter("id = %@", address.id)
//        try! realm.write {
//            realm.delete(deletingAddress)
//        }
//    }
//}

protocol RealmPathable {
    func realm(path: RealmType) -> Realm
}

extension RealmPathable {

    func realm(path: RealmType) -> Realm {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(path).realm")
        return try! Realm(configuration: config)
    }

}

protocol RealmLikeDislikeProtocol: RealmPathable {

    func isLiked(product: Wine) -> Bool
    func toOrUnLike(product: Wine)
    func addToLike(wine: Wine)
    func removeToLike(product: Wine)
    func allLiked() -> [Wine]
    func hasLiked() -> Bool


    func isDisliked(product: Wine) -> Bool
    func toOrUnDislike(product: Wine)
    func addToDislike(product: Wine)
    func removeToDislike(product: Wine)
    func allDisliked() -> [Wine]
    func hasDisliked() -> Bool

}

enum RealmType: String {
    case like, dislike, notes
}

extension RealmLikeDislikeProtocol {

    func isLiked(product: Wine) -> Bool { // db
        return realm(path: .like).object(ofType: Wine.self, forPrimaryKey: product.id) != nil
    }

    func toOrUnLike(product: Wine) {
        if isLiked(product: product) {
            removeToLike(product: product)
        } else {
            addToLike(wine: product)
        }
    }

    func addToLike(wine: Wine) {
        let savingProduct = Wine()
        savingProduct.id = wine.id
        savingProduct.title = wine.title
        savingProduct.desc = wine.desc
        savingProduct.mainImageUrl = wine.mainImageUrl
        savingProduct.price = wine.price
        savingProduct.dishCompatibility = wine.dishCompatibility

        try! realm(path: .like).write {
            realm(path: .like).create(Wine.self, value: savingProduct, update: .all)
        }
    }

    func removeToLike(product: Wine) {
        let deletingProduct = realm(path: .like).objects(Wine.self).filter("id = %@", product.id)
        try! realm(path: .like).write {
            realm(path: .like).delete(deletingProduct)
        }
    }

    func allLiked() -> [Wine] { // db
        let objs = realm(path: .like).objects(Wine.self)
        return Array<Wine>(objs)
    }

    func hasLiked() -> Bool { // db
        return !realm(path: .like).objects(Wine.self).isEmpty
    }

    ////////////////

    func isDisliked(product: Wine) -> Bool {
        return realm(path: .dislike).object(ofType: Wine.self, forPrimaryKey: product.id) != nil
    }

    func toOrUnDislike(product: Wine) {
        if isDisliked(product: product) {
            removeToDislike(product: product)
        } else {
            addToDislike(product: product)
        }
    }

    func addToDislike(product: Wine) {
        let savingProduct = Wine()
        savingProduct.id = product.id
        savingProduct.title = product.title
        savingProduct.desc = product.desc
        savingProduct.mainImageUrl = product.mainImageUrl
        savingProduct.price = product.price

        try! realm(path: .dislike).write {
            realm(path: .dislike).create(Wine.self, value: savingProduct, update: .all)
        }
    }

    func removeToDislike(product: Wine) {
        let deletingProduct = realm(path: .dislike).objects(Wine.self).filter("id = %@", product.id)
        try! realm(path: .dislike).write {
            realm(path: .dislike).delete(deletingProduct)
        }
    }

    func allDisliked() -> [Wine] {
        let objs = realm(path: .dislike).objects(Wine.self)
        return Array<Wine>(objs)
    }

    func hasDisliked() -> Bool {
        return !realm(path: .dislike).objects(Wine.self).isEmpty
    }
}


protocol RealmNotes: RealmPathable {

    func isNoted(product: Wine) -> Bool
    func addToNote(note: Note)
    func removeToNote(note: Note)
    func allNotes() -> [Note]
    func hasNotes() -> Bool
}

extension RealmNotes {

    func isNoted(product: Wine) -> Bool {
        return realm(path: .notes).object(ofType: Note.self, forPrimaryKey: product.id) != nil
    }

    func addToNote(note: Note) {
        let savingNote = Note()
        savingNote.id = note.id
        savingNote.title = note.title
        savingNote.product = note.product
        savingNote.fullReview = note.fullReview

        try! realm(path: .notes).write {
            realm(path: .notes).create(Note.self, value: savingNote, update: .all)
        }
    }

    func removeToNote(note: Note) {
        let deletingNote = realm(path: .notes).objects(Note.self).filter("id = %@", note.id)
        try! realm(path: .notes).write {
            realm(path: .notes).delete(deletingNote)
        }
    }

    func allNotes() -> [Note] {
        let objs = realm(path: .notes).objects(Note.self)
        return Array<Note>(objs)
    }

    func hasNotes() -> Bool {
        return !realm(path: .notes).objects(Note.self).isEmpty
    }

}
