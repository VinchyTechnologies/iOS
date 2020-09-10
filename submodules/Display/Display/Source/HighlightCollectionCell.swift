//
//  HighlightCollectionCell.swift
//  Display
//
//  Created by Aleksei Smirnov on 10.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

open class HighlightCollectionCell: UICollectionViewCell, HighlightableViewProtocol, CollectionCellProtocol {

    public override var isHighlighted: Bool {
        didSet {
            highlightAnimator?.animateHighlight()
        }
    }

    public var highlightStyle: CollectionCellHighlightStyle? {
        didSet {
            guard highlightStyle != oldValue else { return }
            highlightAnimator = self.highlightAnimator(for: highlightStyle)
        }
    }

    private var highlightAnimator: HighlightAnimatorProtocol?

    private func highlightAnimator(for style: CollectionCellHighlightStyle?) -> HighlightAnimatorProtocol? {
        switch style {
        case .scale:
            return ScaleHighlightAnimator(view: self)
        case let .backgroundColor(color):
            return BackgroundColorHighlightAnimator(view: self, highlightedBackgroundColor: color)
        case .none:
            return nil
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) { fatalError() }

}
