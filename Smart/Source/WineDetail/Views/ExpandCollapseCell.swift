//
//  ExpandCollapseCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 27.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - ExpandCollapseCellViewModel

struct ExpandCollapseCellViewModel: ViewModelProtocol {

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

// MARK: - ExpandCollapseCell

final class ExpandCollapseCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .mainBackground

    contentView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -(4 + 20)),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ])

    contentView.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
      imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 20),
      imageView.heightAnchor.constraint(equalToConstant: 20),
    ])
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Private

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

// MARK: Decoratable

extension ExpandCollapseCell: Decoratable {
  typealias ViewModel = ExpandCollapseCellViewModel

  func decorate(model: ViewModel) {
    if model.animated {

      UIView.transition(with: titleLabel, duration: 0.25, options: [.beginFromCurrentState, .transitionCrossDissolve, .layoutSubviews, .curveEaseIn]) {
        self.titleLabel.text = model.titleText
      } completion: { _ in }

      UIView.animate(withDuration: 0.25, delay: 0.0, options: [.beginFromCurrentState, .layoutSubviews, .curveEaseIn]) {
        switch model.chevronDirection {
        case .up:
          self.imageView.transform = CGAffineTransform(rotationAngle: .pi)

        case .down:
          self.imageView.transform = CGAffineTransform(rotationAngle: -2 * .pi)
        }

        self.layoutIfNeeded()
      } completion: { _ in }
    } else {
      titleLabel.text = model.titleText
      switch model.chevronDirection {
      case .up:
        imageView.transform = CGAffineTransform(rotationAngle: .pi)

      case .down:
        break
      }
    }
  }
}
