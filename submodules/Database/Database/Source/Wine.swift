//
//  Wine.swift
//  Database
//
//  Created by Aleksei Smirnov on 13.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

//import RealmSwift
//
//public protocol HasPrimaryKeyID: Object {
//  dynamic var id: Int64 { get }
//  static func myPrimaryKey() -> String
//}
//
//extension HasPrimaryKeyID where Self: Object {
//  public static func myPrimaryKey() -> String {
//    "id"
//  }
//}
//
//public final class DBWine: Object, HasPrimaryKeyID {
//
//  @objc public dynamic var id: Int64 = 0
//  @objc public dynamic var wineID: Int64 = 0
//  @objc public dynamic var title: String = ""
//
//  public override class func primaryKey() -> String {
//    myPrimaryKey()
//  }
//
//  public convenience init(id: Int64, wineID: Int64, title: String) {
//    self.init()
//    self.id = id
//    self.wineID = wineID
//    self.title = title
//  }
//}
