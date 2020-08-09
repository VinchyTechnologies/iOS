//
//  CartItem.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 16.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import RealmSwift
import Core

final class CartItem: Object {

    @objc dynamic var id: Int64 = 0
    @objc dynamic var product: Wine!
    @objc dynamic var number: Int = 0

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(id: String? = nil, product: Wine, number: Int) {
        self.init()
        self.id = product.id
        self.product = product
        self.number = number
    }
}
