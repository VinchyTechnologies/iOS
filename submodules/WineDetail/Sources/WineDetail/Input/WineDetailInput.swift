//
//  WineDetailInput.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import VinchyUI

public struct WineDetailInput {

  public let wineID: Int64
  public let isAppClip: Bool
  public let shouldShowSimilarWine: Bool
  public let mode: WineDetailMode

  public init(wineID: Int64, mode: WineDetailMode, isAppClip: Bool, shouldShowSimilarWine: Bool) {
    self.wineID = wineID
    self.mode = mode
    self.isAppClip = isAppClip
    self.shouldShowSimilarWine = shouldShowSimilarWine
  }
}
