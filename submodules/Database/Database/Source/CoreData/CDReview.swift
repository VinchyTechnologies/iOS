//
//  CDReview+CoreDataProperties.swift
//  
//
//  Created by Алексей Смирнов on 20.03.2021.
//
//

import Foundation
import CoreData

public enum Estimation: String {
  case like, dislike
}

@objc(CDReview)
public class CDReview: NSManagedObject {

  public func setValues(estimation: Estimation?, noteText: String?, wine: CDWine) {
    setValue(estimation?.rawValue, forKey: "estimation")
    setValue(noteText, forKey: "noteText")
    setValue(wine, forKey: "wine")
  }
}

extension CDReview {
  
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<CDReview> {
    return NSFetchRequest<CDReview>(entityName: "CDReview")
  }
  
  @NSManaged public var estimation: String?
  @NSManaged public var noteText: String?
  @NSManaged public var wine: CDWine
  
}
