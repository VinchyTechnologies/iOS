//
//  ShowcaseLayout.swift
//  Smart
//
//  Created by Алексей Смирнов on 18.01.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - LeftAlignedCollectionViewFlowLayout

final class ShowcaseLayout: UICollectionViewFlowLayout {

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let attributes = super.layoutAttributesForElements(in: rect)
    var leftMargin = sectionInset.left
    var maxY: CGFloat = -1.0
    attributes?.forEach { layoutAttribute in
      if layoutAttribute.representedElementCategory == .cell {
        if layoutAttribute.frame.origin.y >= maxY {
          leftMargin = sectionInset.left
        }

        layoutAttribute.frame.origin.x = leftMargin

        leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
        maxY = max(layoutAttribute.frame.maxY , maxY)
      }
    }

    return attributes
  }
}
