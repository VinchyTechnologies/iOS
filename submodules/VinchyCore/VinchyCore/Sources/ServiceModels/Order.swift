//
//  Order.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 20.02.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import Foundation

public struct Order: Decodable {
  public let id: Int

  public init(id: Int) {
    self.id = id
  }
}
