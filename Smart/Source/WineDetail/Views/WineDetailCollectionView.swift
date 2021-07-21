//
//  WineDetailCollectionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// https://www.coder.work/article/7493934 bug iOS 14.3
final class WineDetailCollectionView: UICollectionView {
  override func layoutSubviews() {
    super.layoutSubviews()

//    guard #available(iOS 14.3, *) else { return }

    subviews.forEach { subview in
      guard
        let scrollView = subview as? UIScrollView,
        let minY = scrollView.subviews.map(\.frame.origin.y).min(),
        minY > scrollView.frame.minY
      else {
        return
      }

      scrollView.contentInset.top = -minY
      scrollView.frame.origin.y = minY
    }
  }
}
