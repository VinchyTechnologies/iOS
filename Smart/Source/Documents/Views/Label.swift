//
//  Label.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import UIKit

// MARK: - Label

final class Label: UILabel, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    font = style.font
    numberOfLines = style.numberOfLines
    if style.showLabelBackground {
      backgroundColor = .secondarySystemBackground
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  // MARK: StyledView

  struct Style: Hashable {
    let font: UIFont
    let showLabelBackground: Bool
    var numberOfLines = 0
  }

  // MARK: ContentConfigurableView

  typealias Content = String

  func setContent(_ content: String, animated: Bool) {
    text = content
  }

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
}
