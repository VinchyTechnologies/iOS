//
//  Button.swift
//  Display
//
//  Created by Алексей Смирнов on 22.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - Button

public final class Button: UIButton {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .accent
    setTitleColor(.white, for: .normal)
    titleLabel?.font = Font.bold(18)
    clipsToBounds = true
    contentEdgeInsets = .init(top: 4, left: 6, bottom: 4, right: 6)
    layer.cornerCurve = .continuous
    startAnimatingPressActions()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  override public func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.height / 2
  }

  public func enable() {
    isEnabled = true
    backgroundColor = .accent
    setTitleColor(.white, for: .normal)
  }

  public func disable() {
    isEnabled = false
    backgroundColor = .option
    setTitleColor(.blueGray, for: .normal)
  }

  //  func startAnimatingPressActions() {
//    addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
//    addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
  //  }

  //  @objc
  //  private func animateDown(sender: UIButton) {
//    let scaleOffset: CGFloat = 8
//    let scale = (frame.width - scaleOffset) / frame.width
//    animate(sender, transform: CGAffineTransform.identity.scaledBy(x: scale, y: scale))
  //  }
//
  //  @objc
  //  private func animateUp(sender: UIButton) {
//    animate(sender, transform: .identity)
  //  }

  //  private func animate(_ button: UIButton, transform: CGAffineTransform) {
//    UIView.animate(
//      withDuration: 0.4,
//      delay: 0,
//      usingSpringWithDamping: 0.5,
//      initialSpringVelocity: 3,
//      options: [.curveEaseInOut],
//      animations: {
//        button.transform = transform
//      },
//      completion: nil)
  //  }
}

// MARK: - ButtonStyle

public enum ButtonStyle {
  case primary
}

extension UIButton {
  func apply(style: ButtonStyle) {
    switch style {
    case .primary:
      break
    }
  }
}

extension UIButton {

  // MARK: Public

  public func startAnimatingPressActions() {
    addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
    addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
  }

  // MARK: Private

  @objc
  private func animateDown(sender: UIButton) {
    let scaleOffset: CGFloat = 8
    let scale = (frame.width - scaleOffset) / frame.width
    animate(sender, transform: CGAffineTransform.identity.scaledBy(x: scale, y: scale))
  }

  @objc
  private func animateUp(sender: UIButton) {
    animate(sender, transform: .identity)
  }

  private func animate(_ button: UIButton, transform: CGAffineTransform) {
    UIView.animate(
      withDuration: 0.4,
      delay: 0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 3,
      options: [.curveEaseInOut],
      animations: {
        button.transform = transform
      },
      completion: nil)
  }
}
