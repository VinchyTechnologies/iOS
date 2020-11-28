//
//  CopyableLabel.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 28.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

public final class CopyableLabel: UILabel {

  override public var canBecomeFirstResponder: Bool {
    true
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    isUserInteractionEnabled = true
    addGestureRecognizer(UILongPressGestureRecognizer(
      target: self,
      action: #selector(showCopyMenu(sender:))))
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  public override func copy(_ sender: Any?) {
    UIPasteboard.general.string = text
    UIMenuController.shared.hideMenu()
  }

  @objc
  private func showCopyMenu(sender: Any?) {
    becomeFirstResponder()
    let menu = UIMenuController.shared
    if !menu.isMenuVisible {
      menu.showMenu(from: self, rect: bounds)
    }
  }

  public override func canPerformAction(
    _ action: Selector,
    withSender sender: Any?)
    -> Bool
  {
    action == #selector(copy(_:))
  }
}
