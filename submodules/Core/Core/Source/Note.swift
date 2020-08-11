//
//  Note.swift
//  Core
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import RealmSwift

public final class Note: Object, HasPrimaryKeyID {

    @objc public dynamic var id: Int64 = 0
    @objc public dynamic var product: Wine!
    @objc public dynamic var title: String = ""
    @objc public dynamic var fullReview: String = ""

    override public class func primaryKey() -> String? {
        return myPrimaryKey()
    }

    public convenience init(id: String? = nil, product: Wine, title: String, fullReview: String) {
        self.init()
        self.id = product.id
        self.product = product
        self.title = title
        self.fullReview = fullReview
    }
}
