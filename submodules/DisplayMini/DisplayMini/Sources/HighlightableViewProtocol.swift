//
//  HighlightableViewProtocol.swift
//  Display
//
//  Created by Aleksei Smirnov on 10.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - HighlightableViewProtocol

public protocol HighlightableViewProtocol: AnyObject {
  var isHighlighted: Bool { get set }
  var highlightableView: UIView { get }
}

extension HighlightableViewProtocol where Self: UICollectionViewCell {
  public var highlightableView: UIView { self }
}

// MARK: - HighlightAnimatorProtocol

public protocol HighlightAnimatorProtocol: AnyObject {
  func animateHighlight()
}

// MARK: - CollectionCellHighlightStyle

public enum CollectionCellHighlightStyle: Equatable {
  case scale
  case backgroundColor(UIColor)
}

// MARK: - CollectionCellProtocol

public protocol CollectionCellProtocol where Self: UICollectionViewCell {
  var highlightStyle: CollectionCellHighlightStyle? { get set }
}

// MARK: - ScaleHighlightAnimator

public final class ScaleHighlightAnimator: HighlightAnimatorProtocol {

  // MARK: Lifecycle

  public init(view: HighlightableViewProtocol) {
    self.view = view
  }

  // MARK: Public

  public func animateHighlight() {
    guard let view = view else { return }
    let transform = self.transform(for: view)
    guard transform != view.highlightableView.transform else { return }
    UIView.animate(
      withDuration: Constants.animationDuration,
      animations: {
        view.highlightableView.transform = transform
      })
  }

  // MARK: Private

  private enum Constants {
    static let animationDuration: TimeInterval = 0.1
    static let scaleOffset: CGFloat = 8
  }

  private weak var view: HighlightableViewProtocol?

  private func transform(for view: HighlightableViewProtocol) -> CGAffineTransform {
    guard view.isHighlighted else { return .identity }
    let scaleOffset = Constants.scaleOffset
    let scale = (view.highlightableView.frame.width - scaleOffset) / view.highlightableView.frame.width
    guard scale > .zero else { return .identity }
    return CGAffineTransform(scaleX: scale, y: scale)
  }
}

// MARK: - BackgroundColorHighlightAnimator

public final class BackgroundColorHighlightAnimator: HighlightAnimatorProtocol {

  // MARK: Lifecycle

  public init(view: HighlightableViewProtocol, highlightedBackgroundColor: UIColor) {
    self.view = view
    originalBackgroundColor = view.highlightableView.backgroundColor
    self.highlightedBackgroundColor = highlightedBackgroundColor
  }

  // MARK: Public

  public func animateHighlight() {
    guard let view = view else { return }
    view.highlightableView.backgroundColor = backgroundColor(for: view)
  }

  // MARK: Private

  private weak var view: HighlightableViewProtocol?
  private let originalBackgroundColor: UIColor?
  private let highlightedBackgroundColor: UIColor

  private func backgroundColor(for view: HighlightableViewProtocol) -> UIColor? {
    view.isHighlighted ? highlightedBackgroundColor : originalBackgroundColor
  }
}
