//
//  PaddingLabel.swift
//  Display
//
//  Created by Aleksei Smirnov on 04.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - PaddingLabel

open class PaddingLabel: UILabel {
  public var insets: UIEdgeInsets = .zero

  override public var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + insets.left + insets.right,
      height: size.height + insets.top + insets.bottom)
  }

  override public var bounds: CGRect {
    didSet {
      preferredMaxLayoutWidth = bounds.width - (insets.left + insets.right)
    }
  }

  override public func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: insets))
  }
}

// MARK: - UIEdgeInsets + Hashable

extension UIEdgeInsets: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(left)
    hasher.combine(right)
    hasher.combine(top)
    hasher.combine(bottom)
  }
}

