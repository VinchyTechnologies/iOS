//
//  MainSubtitleCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - MainSubtitleCollectionCellViewModel

struct MainSubtitleCollectionCellViewModel: ViewModelProtocol, Hashable {
  fileprivate let subtitleText: String?
  fileprivate let imageURL: URL?

  private let identifier = UUID()

  public init(subtitleText: String?, imageURL: URL?) {
    self.subtitleText = subtitleText
    self.imageURL = imageURL
  }
}

// MARK: - MainSubtitleCollectionCell

final class MainSubtitleCollectionCell: HighlightCollectionCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    highlightStyle = .scale

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .option
    imageView.contentMode = .scaleToFill
    imageView.layer.cornerRadius = 15
    imageView.clipsToBounds = true

    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.font = Font.semibold(15)
    subtitleLabel.textColor = .blueGray

    addSubview(imageView)
    addSubview(subtitleLabel)
    NSLayoutConstraint.activate([
      subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -3),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Private

  private let subtitleLabel = UILabel()
  private let imageView = UIImageView()
}

// MARK: Decoratable

extension MainSubtitleCollectionCell: Decoratable {
  typealias ViewModel = MainSubtitleCollectionCellViewModel

  func decorate(model: ViewModel) {
    subtitleLabel.text = model.subtitleText
    imageView.loadImage(url: model.imageURL)
  }
}
