//
//  Example
//  man.li
//
//  Created by man.li on 11/11/2018.
//  Copyright © 2020 man.li. All rights reserved.
//

import UIKit

// MARK: - WindowDelegate

protocol WindowDelegate: AnyObject {
  func isPointEvent(point: CGPoint) -> Bool
}

// MARK: - CocoaDebugWindow

class CocoaDebugWindow: UIWindow {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .clear
    windowLevel = UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue - 1)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal


  weak var delegate: WindowDelegate?

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    delegate?.isPointEvent(point: point) ?? false
  }
}

// MARK: - WindowHelper + WindowDelegate

extension WindowHelper: WindowDelegate {
  func isPointEvent(point: CGPoint) -> Bool {
    vc.shouldReceive(point: point)
  }
}
