//
//  SwitcherWithText.swift
//  Smart
//
//  Created by Aleksei Smirnov on 22.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - SwitcherWithTextViewModel

struct SwitcherWithTextViewModel: ViewModelProtocol {
  fileprivate let attributedText: NSAttributedString

  init(attributedText: NSAttributedString) {
    self.attributedText = attributedText
  }
}

// MARK: - SwitcherWithText

final class SwitcherWithText: UIView {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    label.numberOfLines = 0
    label.setContentCompressionResistancePriority(.required, for: .horizontal)

    switcher.setContentCompressionResistancePriority(.required, for: .horizontal)
    switcher.onTintColor = .accent

    let stackView = UIStackView(arrangedSubviews: [
      label,
      switcher,
    ])

    stackView.distribution = .equalSpacing
    stackView.setCustomSpacing(20, after: label)
    stackView.axis = .horizontal

    addSubview(stackView)
    stackView.fill()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  private(set) var label = UILabel()
  private(set) var switcher = UISwitch()
}

// MARK: Decoratable

extension SwitcherWithText: Decoratable {
  typealias ViewModel = SwitcherWithTextViewModel

  func decorate(model: ViewModel) {
    label.attributedText = model.attributedText
  }
}
