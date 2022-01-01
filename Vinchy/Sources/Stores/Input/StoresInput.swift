//
//  StoresInput.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

struct StoresInput {
  let mode: Mode

  enum Mode {
    case wine(wineID: Int64)
    case saved
  }

  init(mode: Mode) {
    self.mode = mode
  }
}
