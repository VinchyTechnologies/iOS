//
//  WineDetailInput.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public struct WineDetailInput {
  public let wineID: Int64
  public let isAppClip: Bool

  public init(wineID: Int64, isAppClip: Bool) {
    self.wineID = wineID
    self.isAppClip = isAppClip
  }
}
