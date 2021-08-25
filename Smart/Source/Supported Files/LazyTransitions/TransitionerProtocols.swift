//
//  TransitionerProtocols.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/2/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Display

var progressThreshold: CGFloat {
  if UIDevice.current.userInterfaceIdiom == .pad {
    if Orientation.isLandscape {
      return 0.05
    } else {
      return 0.15
    }
  } else {
    return 0.3
  }
}

// MARK: - TransitionerDelegate

public protocol TransitionerDelegate: AnyObject {
  func finishedInteractiveTransition(_ completed: Bool)
  func beginTransition(with transitioner: TransitionerType)
}

extension TransitionerDelegate {
  public func finishedInteractiveTransition(_ completed: Bool) { }
}

// MARK: - TransitionerType

public protocol TransitionerType: AnyObject {
  var animator: TransitionAnimatorType { get }
  var interactor: TransitionInteractor? { get }
  var delegate: TransitionerDelegate? { get set }
}

// MARK: - InteractiveTransitionerType

public protocol InteractiveTransitionerType: TransitionerType {
  var gestureHandler: TransitionGestureHandlerType { get }
  init(
    with gestureHandler: TransitionGestureHandlerType,
    with animator: TransitionAnimatorType,
    with interactor: TransitionInteractor)
}

extension TransitionerType {
  public var interactor: TransitionInteractor? {
    nil
  }
}
