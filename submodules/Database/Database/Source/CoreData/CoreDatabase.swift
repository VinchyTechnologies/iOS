//
//  CoreDatabase.swift
//  Database
//
//  Created by Алексей Смирнов on 18.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreData

public final class CoreDatabase<T: NSManagedObject> {
  
  public lazy var persistentContainer: NSPersistentContainer = {
    let bundle = Bundle(for: type(of: self))
    guard
      let modelURL = bundle.url(
            forResource: "Vinchy",
            withExtension: "momd")
    else {
      fatalError("Failed to find data model")
    }
    
    guard
      let mom = NSManagedObjectModel(
        contentsOf: modelURL)
    else {
        fatalError("Failed to create model from file: \(modelURL)")
    }
    
    let container = NSPersistentContainer(name: "Vinchy", managedObjectModel: mom)
        
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
    
  public init() { }
  
  public func isEmpty(entityName: String) -> Bool {
    do {
      let request = NSFetchRequest<T>(entityName: entityName)
      let count = try persistentContainer.viewContext.count(for: request)
      return count == 0
    } catch {
      return true
    }
  }
  
  public func fetchAll(entityName: String, predicate: NSPredicate? = nil) -> [T] {
    let fetchRequest = NSFetchRequest<T>(entityName: entityName)
    fetchRequest.predicate = predicate
    do {
      return try persistentContainer.viewContext.fetch(fetchRequest)
    } catch {
      return []
    }
  }
  
  public func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
//
//  public func remove(object: HasPrimaryKeyID, at path: RealmType) {
//    let deletingObject = realm(path: path).objects(T.self).filter("id = %@", object.id)
//    try! realm(path: path).write {// swiftlint:disable:this force_try
//      realm(path: path).delete(deletingObject)
//    }
//  }
//
//  public func filter(at path: RealmType, predicate: NSPredicate) -> [T] {
//    let search = realm(path: path).objects(T.self).filter(predicate)
//    return  Array<T>(search)
//  }
}
