//
//  WriteNoteInput.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import VinchyCore

struct WriteNoteInput {
  enum WriteNoteWine {
    case database(note: VNote)
    case firstTime(wine: Wine)
  }

  let wine: WriteNoteWine
}
