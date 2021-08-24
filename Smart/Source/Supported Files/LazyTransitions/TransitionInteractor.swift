//
//  TransitionInteractor.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 1/18/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import UIKit

public class TransitionInteractor: UIPercentDrivenInteractiveTransition {

  // MARK: Public

  public static func `default`() -> TransitionInteractor {
    let transitionInteractor = TransitionInteractor()
    transitionInteractor.completionCurve = .easeInOut
    return transitionInteractor
  }

  public func setCompletionSpeedForFinish() {
    completionSpeed = 1.0
  }

  public func setCompletionSpeedForCancel() {
    // if completionSpeed is not of the default value in iOS 8 it will show a jerky visual glitch.
    completionSpeed = isiOS9 ? 0.5 : 1.0
  }

  // MARK: Fileprivate

  fileprivate let isiOS9: Bool = {
    if #available(iOS 9.0, *) { return true }
    return false
  }()
}
