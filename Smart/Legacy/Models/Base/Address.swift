//
//  Address.swift
//  Smart
//
//  Created by Aleksei Smirnov on 10.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import RealmSwift

final class Address: Object, Codable {

    @objc dynamic var id: String = ""
    @objc dynamic var fullName: String = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0

    override class func primaryKey() -> String {
        return "id"
    }

    convenience init(fullName: String, lat: Double, lon: Double) {
        self.init()
        self.id = UUID().uuidString
        self.fullName = fullName
        self.lat = lat
        self.lon = lon
    }
}
