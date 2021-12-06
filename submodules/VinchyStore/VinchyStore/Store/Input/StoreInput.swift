//
//  StoreInput.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

public struct StoreInput {

  public enum Mode {
    case normal(affilatedId: Int)
    case hasPersonalRecommendations(affilatedId: Int, wines: [ShortWine])
  }

  public let mode: Mode
  public let isAppClip: Bool

  public init(mode: Mode, isAppClip: Bool) {
    self.mode = mode
    self.isAppClip = isAppClip
  }
}
