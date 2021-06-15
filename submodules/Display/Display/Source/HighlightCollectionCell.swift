//
//  HighlightCollectionCell.swift
//  Display
//
//  Created by Aleksei Smirnov on 10.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

open class HighlightCollectionCell: UICollectionViewCell, HighlightableViewProtocol, CollectionCellProtocol {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable)
  public required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  override public var isHighlighted: Bool {
    didSet {
      highlightAnimator?.animateHighlight()
    }
  }

  public var highlightStyle: CollectionCellHighlightStyle? {
    didSet {
      guard highlightStyle != oldValue else { return }
      highlightAnimator = highlightAnimator(for: highlightStyle)
    }
  }

  // MARK: Private

  private var highlightAnimator: HighlightAnimatorProtocol?

  private func highlightAnimator(for style: CollectionCellHighlightStyle?) -> HighlightAnimatorProtocol? {
    switch style {
    case .scale:
      return ScaleHighlightAnimator(view: self)
    case .backgroundColor(let color):
      return BackgroundColorHighlightAnimator(view: self, highlightedBackgroundColor: color)
    case .none:
      return nil
    }
  }
}
