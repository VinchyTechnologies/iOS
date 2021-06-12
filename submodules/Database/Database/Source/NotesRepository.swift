//
//  NotesRepository.swift
//  Database
//
//  Created by Алексей Смирнов on 11.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public let notesRepository = NotesRepository() // TODO: - DI

public class VNote: Codable, DIdentifiable, DSortable, Equatable {
  
  public static func == (lhs: VNote, rhs: VNote) -> Bool {
    lhs.id == rhs.id
  }
  
  public typealias Id = Int // swiftlint:disable:this type_name
  
  public static var sorting: (VNote, VNote) -> Bool {
    { $0.id < $1.id }
  }
  
  public let id: Int
  public let wineID: Int64?
  public let wineTitle: String?
  public let noteText: String?
  
  public init(id: Int, wineID: Int64?, wineTitle: String?, noteText: String?) {
    self.id = id
    self.wineID = wineID
    self.wineTitle = wineTitle
    self.noteText = noteText
  }
}

public final class NotesRepository: CollectionRepository<VNote> {
        
  public init() {
      super.init(storage: InMemoryStorageWithFilePersistance().toAny())
  }
}

extension VNote {
  @objc
  public func value(forKey key: String) -> Any? {
    switch key {
    case "id":
      return id
      
    case "wineID":
      return wineID
      
    case "wineTitle":
      return wineTitle
      
    case "noteText":
      return noteText
      
    default:
      return nil
    }
  }
}
