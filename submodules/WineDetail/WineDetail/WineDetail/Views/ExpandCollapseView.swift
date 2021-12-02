//
//  ExpandCollapseView.swift
//  Smart
//
//  Created by Алексей Смирнов on 27.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy
import UIKit

// MARK: - ExpandCollapseCellViewModel

struct ExpandCollapseCellViewModel: ViewModelProtocol, Equatable {

  enum ChevronDirection {
    case up, down
  }

  fileprivate let chevronDirection: ChevronDirection
  fileprivate let titleText: String?
  fileprivate let animated: Bool

  init(chevronDirection: ChevronDirection, titleText: String?, animated: Bool) {
    self.chevronDirection = chevronDirection
    self.titleText = titleText
    self.animated = animated
  }
}

// MARK: - ExpandCollapseView

final class ExpandCollapseView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    backgroundColor = .mainBackground

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -4 - 20),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])

    addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 20),
      imageView.heightAnchor.constraint(equalToConstant: 20),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

  }

  typealias Content = ExpandCollapseCellViewModel

  func setContent(_ content: Content, animated: Bool) {
    if content.animated {

      UIView.transition(with: titleLabel, duration: 0.25, options: [.beginFromCurrentState, .transitionCrossDissolve, .layoutSubviews, .curveEaseIn]) {
        self.titleLabel.text = content.titleText
      } completion: { _ in }

      UIView.animate(withDuration: 0.25, delay: 0.0, options: [.beginFromCurrentState, .layoutSubviews, .curveEaseIn]) {
        switch content.chevronDirection {
        case .up:
          self.imageView.transform = CGAffineTransform(rotationAngle: .pi)

        case .down:
          self.imageView.transform = CGAffineTransform(rotationAngle: -2 * .pi)
        }

        self.layoutIfNeeded()
      } completion: { _ in }
    } else {
      titleLabel.text = content.titleText
      switch content.chevronDirection {
      case .up:
        imageView.transform = CGAffineTransform(rotationAngle: .pi)

      case .down:
        imageView.transform = CGAffineTransform(rotationAngle: -2 * .pi)
      }
    }
  }

  // MARK: Private

  private let style: Style
  private let titleLabel: UILabel = {
    $0.textColor = .accent
    $0.font = Font.medium(16)
    return $0
  }(UILabel())

  private let imageView: UIImageView = {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .default)
    $0.image = UIImage(systemName: "chevron.down", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal)
    return $0
  }(UIImageView())
}
