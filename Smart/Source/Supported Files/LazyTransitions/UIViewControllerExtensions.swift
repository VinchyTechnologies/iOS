//
//  UIViewControllerExtensions.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 1/2/19.
//  Copyright © 2019 BeardWare. All rights reserved.
//

import Foundation

extension UIViewController {

  // MARK: Public

  public var allowedOrientations: [TransitionOrientation] {
    get {
      transitioner?.allowedOrientations ?? []
    }

    set {
      transitioner?.allowedOrientations = newValue
    }
  }

  public func becomeLazy(
    for transitionType: TransitionType,
    animator: TransitionAnimatorType? = nil,
    interactor: TransitionInteractor? = nil,
    presentation: Presentation? = nil)
  {
    if transitioner != nil { return }

    transitioner = .init(
      lazyScreen: self,
      transition: transitionType,
      animator: animator,
      interactor: interactor,
      presentation: presentation)
  }

  public func addTransition(forScrollView scrollView: UIScrollView, bouncyEdges: Bool = true) {
    transitioner?.addTransition(forScrollView: scrollView, bouncyEdges: bouncyEdges)
  }

  public func addTransition(forView view: UIView) {
    transitioner?.addTransition(forView: view)
  }

  public func removeTransitions(for view: UIView) {
    transitioner?.removeTransitions(for: view)
  }

  // MARK: Internal

  var transitioner: LazyTransitioner? {
    get {
      objc_getAssociatedObject(self, &UIViewController.transitionerKey) as? LazyTransitioner
    }
    set {
      objc_setAssociatedObject(
        self,
        &UIViewController.transitionerKey,
        newValue as LazyTransitioner?,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  // MARK: Private

  private static var transitionerKey = "LazyTransitions"

}
