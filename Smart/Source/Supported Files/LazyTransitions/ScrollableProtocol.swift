//
//  ScrollableProtocol.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 1/2/17.
//  Copyright © 2017 BeardWare. All rights reserved.
//

import Foundation

// MARK: - Scrollable

public protocol Scrollable: AnyObject {
  var isAtTop: Bool { get }
  var isAtBottom: Bool { get }
  var isAtLeftEdge: Bool { get }
  var isAtRightEdge: Bool { get }
  var isSomewhereInVerticalMiddle: Bool { get }
  var isSomewhereInHorizontalMiddle: Bool { get }
  var bounces: Bool { get set }
}

extension Scrollable {
  public var possibleVerticalOrientation: TransitionOrientation {
    isAtTop ? .topToBottom : .bottomToTop
  }

  public var possibleHorizontalOrientation: TransitionOrientation {
    isAtLeftEdge ? .leftToRight : .rightToLeft
  }

  public var scrollsHorizontally: Bool {
    !(isAtRightEdge && isAtLeftEdge)
  }

  public var scrollsVertically: Bool {
    !(isAtTop && isAtBottom)
  }
}
