//
//  ReviewedWine.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 12.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

public struct ReviewedWine: Decodable {
  public let review: Review?
  public let wine: ShortWine?
}
