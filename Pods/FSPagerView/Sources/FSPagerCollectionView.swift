//
//  FSPagerCollectionView.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 24/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//
//  1. Reject -[UIScrollView(UIScrollViewInternal) _adjustContentOffsetIfNecessary]
//  2. Group initialized features

import UIKit

class FSPagerCollectionView: UICollectionView {

  // MARK: Lifecycle


  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  // MARK: Internal


  #if !os(tvOS)
  override var scrollsToTop: Bool {
    set {
      super.scrollsToTop = false
    }
    get {
      false
    }
  }
  #endif

  override var contentInset: UIEdgeInsets {
    set {
      super.contentInset = .zero
      if newValue.top > 0 {
        let contentOffset = CGPoint(x:self.contentOffset.x, y:self.contentOffset.y+newValue.top);
        self.contentOffset = contentOffset
      }
    }
    get {
      super.contentInset
    }
  }

  // MARK: Fileprivate


  fileprivate func commonInit() {
    contentInset = .zero
    decelerationRate = UIScrollView.DecelerationRate.fast
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    if #available(iOS 10.0, *) {
      self.isPrefetchingEnabled = false
    }
    if #available(iOS 11.0, *) {
      self.contentInsetAdjustmentBehavior = .never
    }
    #if !os(tvOS)
    scrollsToTop = false
    isPagingEnabled = false
    #endif
  }

}
