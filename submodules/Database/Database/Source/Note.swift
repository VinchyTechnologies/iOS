//
//  Note.swift
//  Database
//
//  Created by Aleksei Smirnov on 13.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import RealmSwift

public final class Note: Object, HasPrimaryKeyID {

  @objc
  public dynamic var id: Int64 = 0

  @objc
  public dynamic var wineID: Int64 = 0

  @objc
  public dynamic var wineTitle: String = ""

  @objc
  public dynamic var wineMainImageURL: String = ""

  @objc
  public dynamic var noteText: String = ""

  override public class func primaryKey() -> String? {
    myPrimaryKey()
  }

  public convenience init(
    id: Int64,
    wineID: Int64,
    wineTitle: String,
    wineMainImageURL: String,
    noteText: String) {

    self.init()
    self.id = id
    self.wineID = wineID
    self.wineTitle = wineTitle
    self.wineMainImageURL = wineMainImageURL
    self.noteText = noteText
  }
}
