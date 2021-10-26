//
//  StoryView.swift
//  Smart
//
//  Created by Алексей Смирнов on 26.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//


import Display
import Epoxy
import UIKit

// MARK: - StoryViewViewModel

struct StoryViewViewModel: Equatable {
  fileprivate let imageURL: URL?
  fileprivate let titleText: String?

  public init(imageURL: URL?, titleText: String?) {
    self.imageURL = imageURL
    self.titleText = titleText
  }
}

// MARK: - StoryView

final class StoryView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)

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

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

  }

  typealias Content = StoryViewViewModel


  func setContent(_ content: Content, animated: Bool) {
    setAttributedText(string: content.titleText)
    imageView.loadImage(url: content.imageURL)
  }

  // MARK: Private

  private let style: Style
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
