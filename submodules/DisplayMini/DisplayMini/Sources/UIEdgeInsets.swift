//
//  UIEdgeInsets.swift
//  Display
//
//  Created by Aleksei Smirnov on 04.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit.UIGeometry

// MARK: - UIEdgeInsets + Hashable

extension UIEdgeInsets: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(left)
    hasher.combine(right)
    hasher.combine(top)
    hasher.combine(bottom)
  }
}
