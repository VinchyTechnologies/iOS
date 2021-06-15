//
//  CopyableLabel.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 28.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

public final class CopyableLabel: UILabel {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)
    isUserInteractionEnabled = true
    addGestureRecognizer(UILongPressGestureRecognizer(
      target: self,
      action: #selector(showCopyMenu(sender:))))
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  override public var canBecomeFirstResponder: Bool {
    true
  }

  override public func copy(_: Any?) {
    UIPasteboard.general.string = text
    UIMenuController.shared.hideMenu()
  }

  override public func canPerformAction(
    _ action: Selector,
    withSender _: Any?)
    -> Bool
  {
    action == #selector(copy(_:))
  }

  // MARK: Private

  @objc
  private func showCopyMenu(sender _: Any?) {
    becomeFirstResponder()
    let menu = UIMenuController.shared
    if !menu.isMenuVisible {
      menu.showMenu(from: self, rect: bounds)
    }
  }
}
