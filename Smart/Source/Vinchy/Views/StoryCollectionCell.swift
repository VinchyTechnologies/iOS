//
//  StoryCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

struct StoryCollectionCellViewModel: ViewModelProtocol, Hashable {

  fileprivate let imageURL: URL?
  fileprivate let titleText: String?

  private let identifier = UUID()

  public init(imageURL: URL?, titleText: String?) {
    self.imageURL = imageURL
    self.titleText = titleText
  }
}

final class StoryCollectionCell: HighlightCollectionCell, Reusable  {

  private let imageView = UIImageView()
  private let titleLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    highlightStyle = .scale

    backgroundColor = .option
    layer.cornerRadius = 12
    clipsToBounds = true

    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)

    titleLabel.font = Font.bold(18)
    titleLabel.textColor = .white
    titleLabel.numberOfLines = 2

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
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

  required init?(coder: NSCoder) { fatalError() }

  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = bounds
  }

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

extension StoryCollectionCell: Decoratable {

  typealias ViewModel = StoryCollectionCellViewModel

  func decorate(model: ViewModel) {
    setAttributedText(string: model.titleText)
    imageView.sd_setImage(with: model.imageURL, placeholderImage: nil, options: [.continueInBackground, .retryFailed, .highPriority, .queryDiskDataSync], completed: nil)
  }
}
