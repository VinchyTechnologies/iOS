//
//  SmartFilterCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 04.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - SmartFilterCollectionCellViewModel

public struct SmartFilterCollectionCellViewModel: ViewModelProtocol {
  fileprivate let accentText: String
  fileprivate let boldText: String
  fileprivate let subtitleText: String
  fileprivate let buttonText: String

  public init(
    accentText: String,
    boldText: String,
    subtitleText: String,
    buttonText: String)
  {
    self.accentText = accentText
    self.boldText = boldText
    self.subtitleText = subtitleText
    self.buttonText = buttonText
  }
}

// MARK: - SmartFilterCollectionCell

final class SmartFilterCollectionCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .option
    layer.cornerRadius = 10
    clipsToBounds = true

    topAccentLabel.font = Font.medium(13)
    topAccentLabel.textColor = .accent
    topAccentLabel.textAlignment = .center

    boldTitleLabel.font = Font.heavy(20)
    boldTitleLabel.textColor = .dark
    boldTitleLabel.textAlignment = .center

    subtitleLabel.font = Font.regular(16)
    subtitleLabel.textColor = .blueGray
    subtitleLabel.textAlignment = .center
    subtitleLabel.numberOfLines = 0

    tryItNowButton.backgroundColor = .accent
    tryItNowButton.setTitleColor(.white, for: .normal)
    tryItNowButton.translatesAutoresizingMaskIntoConstraints = false
    tryItNowButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    tryItNowButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    tryItNowButton.layer.cornerRadius = 10
    tryItNowButton.clipsToBounds = true
    tryItNowButton.titleLabel?.font = Font.bold(18)

    let stackView = UIStackView(arrangedSubviews: [
      topAccentLabel,
      boldTitleLabel,
      subtitleLabel,
      tryItNowButton,
    ])

    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Private

  private let topAccentLabel = UILabel()
  private let boldTitleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let tryItNowButton = UIButton()
}

// MARK: Decoratable

extension SmartFilterCollectionCell: Decoratable {
  typealias ViewModel = SmartFilterCollectionCellViewModel

  func decorate(model: ViewModel) {
    topAccentLabel.text = model.accentText
    boldTitleLabel.text = model.boldText
    subtitleLabel.text = model.subtitleText
    tryItNowButton.setTitle(model.buttonText, for: .normal)
  }
}
