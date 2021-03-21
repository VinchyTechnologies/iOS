//
//  CDWine+CoreDataProperties.swift
//  
//
//  Created by Алексей Смирнов on 20.03.2021.
//
//

import Foundation
import CoreData

@objc(CDWine)
public class CDWine: NSManagedObject {

  public func setValues(wineID: Int64, title: String) {
    setValue(wineID, forKey: "wineID")
    setValue(title, forKey: "title")
  }
}

extension CDWine {
  
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<CDWine> {
    return NSFetchRequest<CDWine>(entityName: "CDWine")
  }
  
  @NSManaged public var wineID: Int64
  @NSManaged public var title: String?
  @NSManaged public var review: CDReview?
  
}
