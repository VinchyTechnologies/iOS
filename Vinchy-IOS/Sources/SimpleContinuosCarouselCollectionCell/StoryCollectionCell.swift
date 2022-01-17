//
//  StoryCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import DisplayMini
import UIKit

// MARK: - StoryCollectionCellViewModel

struct StoryCollectionCellViewModel: ViewModelProtocol, Hashable {
  fileprivate let imageURL: URL?
  fileprivate let titleText: String?

  private let identifier = UUID()

  public init(imageURL: URL?, titleText: String?) {
    self.imageURL = imageURL
    self.titleText = titleText
  }
}

// MARK: - StoryCollectionCell

final class StoryCollectionCell: HighlightCollectionCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    highlightStyle = .scale

    backgroundColor = .option
    layer.cornerRadius = 12
    clipsToBounds = true

    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)
    imageView.fill()

    titleLabel.font = Font.bold(16)
    titleLabel.textColor = .white
    titleLabel.numberOfLines = 2

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
    ])

    let gradientView = GradientView(frame: .zero)
    insertSubview(gradientView, aboveSubview: imageView)
    gradientView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      gradientView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -15),
      gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
      gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
      gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  // MARK: Private

  private let imageView = UIImageView()
  private let titleLabel = UILabel()

  private func setAttributedText(string: String?) {
    guard let string = string else { return }
    let attributedString = NSMutableAttributedString(string: string)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.22
    attributedString.addAttribute(
      NSAttributedString.Key.paragraphStyle,
      value: paragraphStyle,
      range: NSRange(location: 0, length: attributedString.length))

    titleLabel.attributedText = attributedString
  }
}

// MARK: Decoratable

extension StoryCollectionCell: Decoratable {
  typealias ViewModel = StoryCollectionCellViewModel

  func decorate(model: ViewModel) {
    setAttributedText(string: model.titleText)
    imageView.loadImage(url: model.imageURL)
  }
}
