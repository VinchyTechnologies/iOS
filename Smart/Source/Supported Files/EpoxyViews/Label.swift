//
//  Label.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import EpoxyCore
import UIKit

// MARK: - TextStyle

enum TextStyle {
  case lagerTitle, miniBold, regular
}

// MARK: - Label

final class Label: UILabel, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
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

  // MARK: Internal

  struct Style: Hashable {
    let font: UIFont
    let showLabelBackground: Bool
    var numberOfLines = 0
    var backgroundColor: UIColor = .mainBackground
    var isRounded: Bool = false
    var textAligment: NSTextAlignment = .left
    var textColor: UIColor = .dark
    var insets: UIEdgeInsets = .zero
  }

  // MARK: ContentConfigurableView

  typealias Content = String

  static func height(for content: Content?, width: CGFloat, style: Style) -> CGFloat {
    guard let content = content else {
      return 0
    }
    // swiftlint:disable:next force_cast
    let font = style.font
    let height = content.height(forWidth: width, font: font)
    return height
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    if style.isRounded {
      layer.cornerRadius = frame.height / 2
      clipsToBounds = true
    }
  }

  func setContent(_ content: String, animated: Bool) {
    text = content
  }

  // MARK: Private

  private let style: Style

}

extension Label.Style {
  static func style(
    with textStyle: UIFont.TextStyle,
    showBackground: Bool = false)
    -> Label.Style
  {
    .init(
      font: UIFont.preferredFont(forTextStyle: textStyle),
      showLabelBackground: showBackground)
  }

  static func style(
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
      return .init(font: Font.heavy(20), showLabelBackground: true)

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
    }
  }
}
