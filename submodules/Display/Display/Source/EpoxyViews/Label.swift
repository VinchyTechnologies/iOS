//
//  Label.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// CopyLabel and Label MUST BE THE SAME!!!

import EpoxyCore
import UIKit

// MARK: - TextStyle

public enum TextStyle {
  case lagerTitle, miniBold, regular, subtitle
}

// MARK: - Label

public final class Label: UILabel, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    font = style.font
    numberOfLines = style.numberOfLines
    if style.showLabelBackground {
      backgroundColor = style.backgroundColor
    }
    textAlignment = style.textAligment
    textColor = style.textColor
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Public

  public struct Style: Hashable {

    // MARK: Lifecycle

    public init(font: UIFont, showLabelBackground: Bool, numberOfLines: Int = 0, backgroundColor: UIColor = .mainBackground, isRounded: Bool = false, textAligment: NSTextAlignment = .left, textColor: UIColor = .dark, insets: UIEdgeInsets = .zero) {
      self.font = font
      self.showLabelBackground = showLabelBackground
      self.numberOfLines = numberOfLines
      self.backgroundColor = backgroundColor
      self.isRounded = isRounded
      self.textAligment = textAligment
      self.textColor = textColor
      self.insets = insets
    }

    // MARK: Public

    public let font: UIFont
    public let showLabelBackground: Bool
    public var numberOfLines: Int = 0
    public var backgroundColor: UIColor = .mainBackground
    public var isRounded: Bool = false
    public var textAligment: NSTextAlignment = .left
    public var textColor: UIColor = .dark
    public var insets: UIEdgeInsets = .zero
  }

  // MARK: ContentConfigurableView

  public typealias Content = String

  public static func width(for content: Content?, maxWidth: CGFloat, style: Style) -> CGFloat {
    guard let content = content else {
      return 0
    }
    let font = style.font
    let width = content.width(usingFont: font)
    return min(maxWidth, width)
  }

  public static func height(for content: Content?, width: CGFloat, style: Style, numberOfLines: Int = 0) -> CGFloat {
    guard let content = content else {
      return 0
    }
    // swiftlint:disable:next force_cast
    let font = style.font
    let height = content.height(forWidth: width, font: font, numberOfLines: numberOfLines)
    return height
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    if style.isRounded {
      layer.cornerRadius = frame.height / 2
      clipsToBounds = true
    }
  }

  public func setContent(_ content: String, animated: Bool) {
    text = content
  }

  // MARK: Private

  private let style: Style

}

extension Label.Style {
  public static func style(
    with textStyle: UIFont.TextStyle,
    showBackground: Bool = false)
    -> Label.Style
  {
    .init(
      font: UIFont.preferredFont(forTextStyle: textStyle),
      showLabelBackground: showBackground)
  }

  public static func style(
    with textStyle: TextStyle,
    backgroundColor: UIColor = .mainBackground,
    numberOfLines: Int = 0,
    isRoundedCorners: Bool = false,
    textAligment: NSTextAlignment = .left,
    textColor: UIColor = .dark,
    insets: UIEdgeInsets = .zero)
    -> Label.Style
  {
    switch textStyle {
    case .lagerTitle:
      return .init(font: Font.heavy(20), showLabelBackground: true, backgroundColor: backgroundColor)

    case .miniBold:
      return .init(
        font: Font.semibold(16),
        showLabelBackground: true,
        numberOfLines: numberOfLines,
        backgroundColor: backgroundColor,
        isRounded: isRoundedCorners,
        textAligment: textAligment,
        textColor: textColor)

    case .regular:
      return .init(
        font: Font.regular(16),
        showLabelBackground: true,
        numberOfLines: numberOfLines,
        backgroundColor: backgroundColor,
        isRounded: isRoundedCorners,
        textAligment: textAligment,
        textColor: textColor)

    case .subtitle:
      return .init(
        font: Font.medium(18),
        showLabelBackground: true,
        numberOfLines: numberOfLines,
        backgroundColor: backgroundColor,
        isRounded: isRoundedCorners,
        textAligment: textAligment,
        textColor: .blueGray)
    }
  }
}

// MARK: - CopyLabel

public final class CopyLabel: CopyableLabel, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    font = style.font
    numberOfLines = style.numberOfLines
    if style.showLabelBackground {
      backgroundColor = style.backgroundColor
    }
    textAlignment = style.textAligment
    textColor = style.textColor
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Public

  public typealias Style = Label.Style

  // MARK: ContentConfigurableView

  public typealias Content = String

  public static func width(for content: Content?, maxWidth: CGFloat, style: Style) -> CGFloat {
    guard let content = content else {
      return 0
    }
    let font = style.font
    let width = content.width(usingFont: font)
    return min(maxWidth, width)
  }

  public static func height(for content: Content?, width: CGFloat, style: Style, numberOfLines: Int = 0) -> CGFloat {
    guard let content = content else {
      return 0
    }
    let font = style.font
    let height = content.height(forWidth: width, font: font, numberOfLines: numberOfLines)
    return height
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    if style.isRounded {
      layer.cornerRadius = frame.height / 2
      clipsToBounds = true
    }
  }

  public func setContent(_ content: String, animated: Bool) {
    text = content
  }

  // MARK: Private

  private let style: Style

}

// MARK: - CopyableLabel

public class CopyableLabel: UILabel {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)
    isUserInteractionEnabled = true
    addGestureRecognizer(UILongPressGestureRecognizer(
      target: self,
      action: #selector(showCopyMenu(sender:))))
  }

  @available(*, unavailable)
  required public init?(coder _: NSCoder) { fatalError() }

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
