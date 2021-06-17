//
//  RateAppCell.swift
//  Coffee
//
//  Created by Алексей Смирнов on 11/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import Display
import StringFormatting
import UIKit

// MARK: - RateAppCellViewModel

public struct RateAppCellViewModel: ViewModelProtocol {
  fileprivate let titleText: String?
  fileprivate let emojiLabel: String?

  public init(titleText: String?, emojiLabel: String?) {
    self.titleText = titleText
    self.emojiLabel = emojiLabel
  }
}

// MARK: - RateAppCell

final class RateAppCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .option

    emojiLabel.translatesAutoresizingMaskIntoConstraints = false
    emojiLabel.textAlignment = .center
    emojiLabel.font = Font.regular(50.0)
    emojiLabel.text = traitCollection.userInterfaceStyle == .dark ? "👍🏿" : "👍"

    addSubview(emojiLabel)
    NSLayoutConstraint.activate([
      emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      emojiLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      emojiLabel.widthAnchor.constraint(equalToConstant: 100),
      emojiLabel.heightAnchor.constraint(equalToConstant: 100),
    ])

    rateTextLabel.translatesAutoresizingMaskIntoConstraints = false
    rateTextLabel.font = Font.bold(20)
    rateTextLabel.textAlignment = .center

    addSubview(rateTextLabel)
    NSLayoutConstraint.activate([
      rateTextLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
      rateTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
      rateTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      rateTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  static func height() -> CGFloat {
    150
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    emojiLabel.text = traitCollection.userInterfaceStyle == .dark ? "👍🏿" : "👍"
  }

  // MARK: Private

  private let emojiLabel = UILabel()
  private let rateTextLabel = UILabel()
}

// MARK: Decoratable

extension RateAppCell: Decoratable {
  typealias ViewModel = RateAppCellViewModel

  func decorate(model: ViewModel) {
    rateTextLabel.text = model.titleText
//    emojiLabel.text = model.emojiLabel
  }
}
