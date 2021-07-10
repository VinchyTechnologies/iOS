//
//  HorizontalWineView.swift
//  Smart
//
//  Created by Алексей Смирнов on 10.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import Epoxy

// MARK: - HorizontalWineViewViewModel

public struct HorizontalWineViewViewModel: Equatable {

  public let wineID: Int64
  fileprivate let imageURL: URL?
  fileprivate let titleText: String
  fileprivate let subtitleText: String?

  public init(
    wineID: Int64,
    imageURL: URL?,
    titleText: String,
    subtitleText: String?)
  {
    self.wineID = wineID
    self.imageURL = imageURL
    self.titleText = titleText
    self.subtitleText = subtitleText
  }
}

// MARK: - HorizontalWineView

final class HorizontalWineView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    bottleImageView.contentMode = .scaleAspectFit

    addSubview(bottleImageView)
    bottleImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottleImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 15),
      bottleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      bottleImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -15),
      bottleImageView.heightAnchor.constraint(equalToConstant: 100),
      bottleImageView.widthAnchor.constraint(equalToConstant: 40),
      bottleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
    ])

    titleLabel.font = Font.bold(24)
    titleLabel.numberOfLines = 2

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: bottleImageView.trailingAnchor, constant: 27),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
    ])

    subtitleLabel.font = Font.medium(16)
    subtitleLabel.textColor = .blueGray

    addSubview(subtitleLabel)
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subtitleLabel.leadingAnchor.constraint(equalTo: bottleImageView.trailingAnchor, constant: 27),
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
    ])
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Internal

  struct Style: Hashable {

  }

  // MARK: ContentConfigurableView

  typealias Content = HorizontalWineViewViewModel

  func setContent(_ content: Content, animated: Bool) {
    bottleImageView.loadBottle(url: content.imageURL)
    titleLabel.text = content.titleText
    subtitleLabel.text = content.subtitleText
  }

  // MARK: Private

  private let bottleImageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
}

// MARK: HighlightableView

extension HorizontalWineView: HighlightableView {
  func didHighlight(_ isHighlighted: Bool) {
    UIView.animate(
      withDuration: 0.15,
      delay: 0,
      options: [.beginFromCurrentState, .allowUserInteraction])
    {
      self.transform = isHighlighted
        ? CGAffineTransform(scaleX: 0.95, y: 0.95)
        : .identity
    }
  }
}


