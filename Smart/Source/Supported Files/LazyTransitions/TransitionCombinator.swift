//
//  TransitionCombinator.swift
//  LazyTransitions
//
//  Created by BeardWare on 12/11/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

// MARK: - TransitionCombinator

public class TransitionCombinator: TransitionerType {

  // MARK: Lifecycle

  public convenience init(
    defaultAnimator: TransitionAnimatorType = DismissAnimator(orientation: .topToBottom),
    transitioners: TransitionerType...)
  {
    self.init(defaultAnimator: defaultAnimator, transitioners: transitioners)
  }

  public init(
    defaultAnimator: TransitionAnimatorType = DismissAnimator(orientation: .topToBottom),
    transitioners: [TransitionerType])
  {
    dismissAnimator = defaultAnimator
    self.transitioners = transitioners
    updateTransitionersDelegate()
  }

  // MARK: Public

  public weak var delegate: TransitionerDelegate?

  public var animator: TransitionAnimatorType {
    currentTransitioner?.animator ?? dismissAnimator
  }
  public var interactor: TransitionInteractor? {
    currentTransitioner?.interactor
  }
  public var allowedOrientations: [TransitionOrientation]? {
    didSet {
      updateAnimatorsAllowedOrientations()
    }
  }
  public private(set) var transitioners: [TransitionerType] {
    didSet {
      updateTransitionersDelegate()
      updateAnimatorsAllowedOrientations()
    }
  }

  public func add(_ transitioner: TransitionerType) {
    transitioners.append(transitioner)
  }

  public func remove(_ transitioner: TransitionerType) {
    let remove: (() -> Void) = { [weak self] in
      self?.transitioners = self?.transitioners.filter { $0 !== transitioner } ?? []
    }

    isTransitionInProgress ? delayedRemove = remove : remove()
  }

  // MARK: Fileprivate

  fileprivate var currentTransitioner: TransitionerType?
  fileprivate let dismissAnimator: TransitionAnimatorType
  fileprivate var delayedRemove: (() -> Void)?

  fileprivate var isTransitionInProgress: Bool {
    currentTransitioner != nil
  }

  fileprivate func updateTransitionersDelegate() {
    transitioners.forEach { $0.delegate = self }
  }

  fileprivate func updateAnimatorsAllowedOrientations() {
    allowedOrientations.apply { orientations in
      transitioners.forEach { $0.animator.allowedOrientations = orientations }
    }
  }
}

// MARK: TransitionerDelegate

extension TransitionCombinator: TransitionerDelegate {
  public func beginTransition(with transitioner: TransitionerType) {
    currentTransitioner = transitioner
    delegate?.beginTransition(with: transitioner)
  }

  public func finishedInteractiveTransition(_ completed: Bool) {
    currentTransitioner = nil
    delayedRemove?()
    delayedRemove = nil
    delegate?.finishedInteractiveTransition(completed)
  }
}

extension TransitionCombinator {
  public func add(_ transitioners: [TransitionerType]) {
    transitioners.forEach { transitioner in add(transitioner) }
  }

  public func remove(_ transitioners: [TransitionerType]) {
    transitioners.forEach { transitioner in remove(transitioner) }
  }
}
