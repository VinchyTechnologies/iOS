//
//  ShortInfoView.swift
//  Smart
//
//  Created by Алексей Смирнов on 10.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy
import UIKit

// MARK: - ShortInfoViewViewModel

struct ShortInfoViewViewModel: Equatable {
  fileprivate let titleText: String?
  fileprivate let subtitleText: String?

  public init(titleText: String?, subtitleText: String?) {
    self.titleText = titleText
    self.subtitleText = subtitleText
  }
}

// MARK: - ShortInfoView

final class ShortInfoView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    backgroundColor = .option
    layer.cornerRadius = 15

    titleLabel.font = Font.semibold(22)
    titleLabel.textColor = .dark

    subtitleLabel.font = Font.with(size: 18, design: .round, traits: .bold)
    subtitleLabel.textColor = .dark

    addSubview(titleLabel)
    addSubview(subtitleLabel)

    [titleLabel, subtitleLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
  }

  typealias Content = ShortInfoViewViewModel

  static func size(for content: Content) -> CGSize {
    let height: CGFloat = 100
    let titleWidth = content.titleText?.width(usingFont: Font.semibold(22))
    let subtitleWidth = content.subtitleText?.width(usingFont: Font.with(size: 18, design: .round, traits: .bold))
    let width = max(titleWidth ?? 0, subtitleWidth ?? 0) + 30
    return CGSize(width: max(width, 130), height: height)
  }

  func setContent(_ content: Content, animated: Bool) {
    titleLabel.text = content.titleText
    subtitleLabel.text = content.subtitleText
  }

  // MARK: Private

  private let style: Style

  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
}
