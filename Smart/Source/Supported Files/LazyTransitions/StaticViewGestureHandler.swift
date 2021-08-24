//
//  StaticViewGestureHandler.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/6/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Display

// MARK: - StaticViewGestureHandler

public class StaticViewGestureHandler: TransitionGestureHandlerType {

  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  public var shouldFinish: Bool = false
  public var didBegin: Bool = false
  public var inProgressTransitionOrientation = TransitionOrientation.unknown
  public weak var delegate: TransitionGestureHandlerDelegate?

  public func didBegin(_ gesture: UIPanGestureRecognizer) {
    HapticEffectHelper.vibrate(withEffect: .heavy)
    UIView.animate(withDuration: 0.25) {
      gesture.view?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
      gesture.view?.layer.cornerRadius = 15
      gesture.view?.clipsToBounds = true
    }
    inProgressTransitionOrientation = gesture.direction.orientation
    didBegin = true
    delegate?.beginInteractiveTransition(with: inProgressTransitionOrientation)
  }

  public func didChange(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: gesture.view)

    if let gesterView = gesture.view {
      gesterView.frame.origin = CGPoint(
        x: gesterView.frame.width + translation.x,
        y: translation.y)
    }

    let progress = calculateTransitionProgressWithTranslation(translation, on: gesture.view)
    shouldFinish = progress > progressThreshold
//    delegate?.updateInteractiveTransitionWithProgress(progress)
  }

  public func didEnd(_ gesture: UIPanGestureRecognizer) {
    if shouldFinish || shouldTransitionByQuickSwipe(gesture) {
      delegate?.finishInteractiveTransition()
    } else {
      if let gesterView = gesture.view {
        UIView.animate(withDuration: 0.25) {
          gesterView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
          gesterView.layer.cornerRadius = 0
          gesterView.clipsToBounds = true
          gesterView.frame.origin = .init(x: gesterView.frame.size.width, y: 0)
        } completion: { _ in
          self.delegate?.cancelInteractiveTransition()
        }
      }
    }

    didBegin = false
  }

  public func calculateTransitionProgressWithTranslation(_ translation: CGPoint, on view: UIView?) -> CGFloat {

    guard let view = view else { return 0 }

    let progress = TransitionProgressCalculator
      .progress(
        for: view,
        withGestureTranslation: translation,
        withTranslationOffset: .zero,
        with: inProgressTransitionOrientation)

    return progress
  }

  public func shouldTransitionByQuickSwipe(_ gesture: UIPanGestureRecognizer) -> Bool {
    false
  }
}

extension UIPanGestureRecognizerDirection {
  public var orientation: TransitionOrientation {
    switch self {
    case .rightToLeft: return .rightToLeft
    case .leftToRight: return .leftToRight
    case .bottomToTop: return .bottomToTop
    case .topToBottom: return .topToBottom
    default: return .unknown
    }
  }
}

extension UIPanGestureRecognizerDirection {
  public var isHorizontal: Bool {
    switch self {
    case .rightToLeft, .leftToRight:
      return true
    default:
      return false
    }
  }
}
