//
//  QRInput.swift
//  Questions
//
//  Created by Алексей Смирнов on 13.03.2022.
//

import Foundation

public struct QRInput {
  public let affilietedId: Int
  public let wineID: Int64

  public init(affilietedId: Int, wineID: Int64) {
    self.affilietedId = affilietedId
    self.wineID = wineID
  }
}
