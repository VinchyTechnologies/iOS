//
//  ScrollViewBounceDecorator.swift
//  Display
//
//  Created by Aleksei Smirnov on 14.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AudioToolbox
import CoreHaptics
import UIKit

// MARK: - ScrollViewBounceDecoratorDelegate

public protocol ScrollViewBounceDecoratorDelegate: AnyObject {
  func scrollViewBounceDecoratorTriggered()
}

// MARK: - ScrollViewBounceDecorator

public final class ScrollViewBounceDecorator {

  // MARK: Lifecycle

  public init(decorationView: UIView, direction: ScrollDirection, isFadingEnabled: Bool, delegate: ScrollViewBounceDecoratorDelegate?) {
    self.decorationView = decorationView
    self.direction = direction
    self.isFadingEnabled = isFadingEnabled
    self.delegate = delegate
  }

  // MARK: Public

  public enum HorizontalPosition {
    case right(UIEdgeInsets)
    case left(UIEdgeInsets)
  }

  public enum ScrollDirection {
    case horizontal(HorizontalPosition)
  }

  public var isEnabled: Bool = false {
    didSet {
      decorationView.isHidden = !isEnabled
    }
  }

  // MARK: - Public methods

  public func configureBounceDecorator(onView view: UIView) {
    guard !view.subviews.contains(decorationView) else { return }

    view.insertSubview(decorationView, at: .zero)
    decorationView.translatesAutoresizingMaskIntoConstraints = false

    switch direction {
    case .horizontal(let position):
      switch position {
      case .left(let insets):
        decorationView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left).isActive = true
        decorationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      case .right(let insets):
        decorationView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right).isActive = true
        decorationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      }
    }
  }

  public func handleScrollViewDidScroll(_ scrollView: UIScrollView) {
    guard isEnabled else { return }

    if let freezeContentOffset = freezeContentOffset {
      scrollView.contentOffset = freezeContentOffset
      return
    }

    let percent = bouncePercent(fromScrollView: scrollView)

    changeZoom(withPercent: percent)
    isTriggered = (percent >= 1.0)
  }

  public func handleScrollViewDidEndDragging(_ scrollView: UIScrollView) {
    guard isTriggered, isEnabled else { return }

    freezeContentOffset = scrollView.contentOffset
    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.freezeTimeoutInterval) {
      self.freezeContentOffset = nil
    }

    delegate?.scrollViewBounceDecoratorTriggered()
  }

  public func changeZoom(withPercent percent: CGFloat) {
    let startValue: CGFloat = Constants.startZoom
    let currentValue = startValue + (1.0 - startValue) * percent

    if isFadingEnabled {
      decorationView.alpha = 1 * percent
    } else {
      decorationView.isHidden = !(currentValue > startValue)
    }
    decorationView.transform = CGAffineTransform.identity.scaledBy(x: currentValue, y: currentValue)
  }

  // MARK: Private

  private enum Constants {
    static let startZoom: CGFloat = 0.5
    static let vibrationSoundId: SystemSoundID = 1519
    static let freezeTimeoutInterval: TimeInterval = 0.25
  }

  private weak var delegate: ScrollViewBounceDecoratorDelegate?

  private let direction: ScrollDirection
  private let decorationView: UIView
  private let isFadingEnabled: Bool

  private var freezeContentOffset: CGPoint?
  private lazy var hapticGenerator = UISelectionFeedbackGenerator()

  private var isTriggered: Bool = false {
    didSet {
      if isTriggered != oldValue, isTriggered {
        if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
          hapticGenerator.selectionChanged()
        } else {
          AudioServicesPlaySystemSound(Constants.vibrationSoundId)
        }
      }
    }
  }

  private var bounceMaxValue: CGFloat {
    var maximumOffset = decorationView.bounds.width

    switch direction {
    case .horizontal(let position):
      switch position {
      case .left(let insets), .right(let insets):
        maximumOffset += insets.horizontal
      }
    }

    return maximumOffset
  }

  // MARK: - Private methods

  private func bouncePercent(fromScrollView scrollView: UIScrollView) -> CGFloat {
    switch direction {
    case .horizontal(let position):
      var offset: CGFloat = .zero

      switch position {
      case .right:
        let contentWidth = scrollView.contentSize.width
        guard contentWidth > .zero else { return .zero }
        let viewWidth = scrollView.bounds.width
        let contentOffset = scrollView.contentOffset.x - scrollView.adjustedContentInset.right
        offset = max(.zero, contentOffset + viewWidth - contentWidth)
      case .left:
        offset = -scrollView.contentOffset.x
      }

      return min(1.0, offset / bounceMaxValue)
    }
  }
}

extension UIEdgeInsets {
  fileprivate var vertical: CGFloat {
    top + bottom
  }

  fileprivate var horizontal: CGFloat {
    left + right
  }
}
