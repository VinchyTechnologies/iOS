//
//  WineCollectionCell.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 05.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - ContextMenuViewModel

public enum ContextMenuViewModel {
  case share(content: ContextMenuItemViewModel)
  case writeNote(content: ContextMenuItemViewModel)
}

// MARK: - ContextMenuItemViewModel

public struct ContextMenuItemViewModel {
  public let title: String?
  public init(title: String?) {
    self.title = title
  }
}

// MARK: - WineCollectionViewCellViewModel

public struct WineCollectionViewCellViewModel: ViewModelProtocol, Hashable {

  // MARK: Lifecycle

  public init(wineID: Int64, imageURL: URL?, titleText: String?, subtitleText: String?, rating: Double?, contextMenuViewModels: [ContextMenuViewModel]?) {
    self.wineID = wineID
    self.imageURL = imageURL
    self.titleText = titleText
    self.subtitleText = subtitleText
    self.rating = rating
    self.contextMenuViewModels = contextMenuViewModels
  }

  // MARK: Public

  public let contextMenuViewModels: [ContextMenuViewModel]?

  public let wineID: Int64
  public let titleText: String?
  public let imageURL: URL?
  public let subtitleText: String?

  public static func == (lhs: WineCollectionViewCellViewModel, rhs: WineCollectionViewCellViewModel) -> Bool {
    lhs.wineID == rhs.wineID
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(wineID)
  }

  // MARK: Fileprivate

  fileprivate let rating: Double?
}

// MARK: - WineCollectionViewCell

public final class WineCollectionViewCell: HighlightCollectionCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    highlightStyle = .scale

    background.backgroundColor = .option
    background.layer.cornerRadius = 40

    contentView.addSubview(background)
    background.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      background.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
    ])

    contentView.addSubview(bottleImageView)
    bottleImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottleImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      bottleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      bottleImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 2 / 3),
      bottleImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 4),
    ])

    background.addSubview(ratingView)
    ratingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
      ratingView.topAnchor.constraint(equalTo: background.topAnchor, constant: 15),
      ratingView.widthAnchor.constraint(equalToConstant: 20),
      ratingView.heightAnchor.constraint(equalToConstant: 20),
    ])

    background.addSubview(ratingLabel)
    ratingLabel.translatesAutoresizingMaskIntoConstraints = false
    ratingLabel.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor).isActive = true
    ratingLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 4).isActive = true

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .equalCentering
    stackView.alignment = .center

    stackView.addArrangedSubview(UIView())
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(subtitleLabel)
    stackView.addArrangedSubview(UIView())

    stackView.setCustomSpacing(2, after: titleLabel)

    contentView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: bottleImageView.bottomAnchor, constant: 0),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
    ])
  }

  // MARK: Private

  private let background = UIView()

  private let bottleImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Font.bold(16)
    label.numberOfLines = 2
    label.textAlignment = .center
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = Font.medium(14)
    label.textColor = .blueGray
    label.textAlignment = .center
    return label
  }()

  private lazy var ratingView: StarsRatingView = {
    $0.settings.filledColor = .accent
    $0.settings.emptyBorderColor = .accent
    $0.settings.filledBorderColor = .accent
    $0.settings.starSize = 24
    $0.settings.fillMode = .precise
    $0.settings.minTouchRating = 0
    $0.settings.starMargin = 0
    $0.isUserInteractionEnabled = false
    $0.settings.totalStars = 1
    return $0
  }(StarsRatingView())

  private let ratingLabel: UILabel = {
    $0.font = Font.with(size: 14, design: .round, traits: .bold)
    $0.textColor = .dark
    $0.textAlignment = .center
    return $0
  }(UILabel())
}

// MARK: Decoratable

extension WineCollectionViewCell: Decoratable {
  public typealias ViewModel = WineCollectionViewCellViewModel

  public func decorate(model: ViewModel) {
    bottleImageView.loadBottle(url: model.imageURL)

    if let title = model.titleText {
      titleLabel.isHidden = false
      titleLabel.text = title
    } else {
      titleLabel.isHidden = true
    }

    if let subtitle = model.subtitleText {
      subtitleLabel.isHidden = false
      subtitleLabel.text = subtitle
    } else {
      subtitleLabel.isHidden = true
    }

    if model.rating == nil || model.rating == 0 {
      ratingView.isHidden = true
      ratingLabel.isHidden = true
    } else {
      ratingView.rating = (model.rating ?? 0) / 5
      ratingLabel.text = String(model.rating ?? 0)
      ratingView.isHidden = false
      ratingLabel.isHidden = false
    }
  }
}
