//
//  StoreInput.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

struct StoreInput {

  enum Mode {
    case normal(affilatedId: Int)
    case hasPersonalRecommendations(affilatedId: Int, wines: [ShortWine])
  }

  let mode: Mode
}
