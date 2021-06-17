//
//  TitleWithSubtitleInfoCollectionViewCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 25.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - TitleWithSubtitleInfoCollectionViewCellViewModel

struct TitleWithSubtitleInfoCollectionViewCellViewModel: ViewModelProtocol {
  fileprivate let titleText: String?
  fileprivate let subtitleText: String?

  init(titleText: String?, subtitleText: String?) {
    self.titleText = titleText
    self.subtitleText = subtitleText
  }
}

// MARK: - TitleWithSubtitleInfoCollectionViewCell

final class TitleWithSubtitleInfoCollectionViewCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    titleLabel.numberOfLines = 0
    subtitleLabel.numberOfLines = 0

    let stackView = UIStackView(arrangedSubviews: [subtitleLabel, titleLabel])
    stackView.axis = .vertical
    stackView.spacing = 2

    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Private

  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
}

// MARK: Decoratable

extension TitleWithSubtitleInfoCollectionViewCell: Decoratable {
  typealias ViewModel = TitleWithSubtitleInfoCollectionViewCellViewModel

  func decorate(model: ViewModel) {
    titleLabel.attributedText = NSAttributedString(string: model.titleText ?? "", font: Font.medium(20), textColor: .dark)

    subtitleLabel.attributedText = NSAttributedString(string: model.subtitleText ?? "", font: Font.regular(14), textColor: .blueGray)
  }
}
