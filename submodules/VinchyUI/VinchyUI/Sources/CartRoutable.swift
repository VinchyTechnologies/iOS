//
//  CartRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 11.02.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import Foundation

public protocol CartRoutable: AnyObject {
  func presentCartViewController(affilatedId: Int)
}
