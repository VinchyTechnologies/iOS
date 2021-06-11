//
//  NotesRepository.swift
//  Database
//
//  Created by Алексей Смирнов on 11.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public let notesRepository = NotesRepository()

public struct VNote: Codable, DIdentifiable, DSortable {
  
  public typealias Id = Int // swiftlint:disable:this type_name
  
  public static var sorting: (VNote, VNote) -> Bool {
    { $0.id < $1.id }
  }
  
  public let id: Int
  
  public let wineID: Int64
  
  public let wineTitle: String

  public let noteText: String
  
  public init(id: Int, wineID: Int64, wineTitle: String, noteText: String) {
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
