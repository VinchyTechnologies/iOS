//
//  HorizontalShopView.swift
//  Smart
//
//  Created by Михаил Исаченко on 09.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import Epoxy

// MARK: - HorizontalPartnerViewViewModel

public struct HorizontalPartnerViewViewModel: Equatable {

  public let affiliatedStoreId: Int
  fileprivate let imageURL: URL?
  fileprivate let titleText: String
  fileprivate let subtitleText: String?

  public init(
    affiliatedStoreId: Int,
    imageURL: URL?,
    titleText: String,
    subtitleText: String?)
  {
    self.affiliatedStoreId = affiliatedStoreId
    self.imageURL = imageURL
    self.titleText = titleText
    self.subtitleText = subtitleText
  }
}

// MARK: - HorizontalPartnerView

final class HorizontalPartnerView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    partnerLogoImageView.contentMode = .scaleAspectFit

    addSubview(partnerLogoImageView)
    partnerLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      partnerLogoImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 15),
      partnerLogoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      partnerLogoImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -15),
      partnerLogoImageView.heightAnchor.constraint(equalToConstant: 100),
      partnerLogoImageView.widthAnchor.constraint(equalToConstant: 40),
      partnerLogoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
    ])

    titleLabel.font = Font.bold(24)
    titleLabel.numberOfLines = 2

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: partnerLogoImageView.trailingAnchor, constant: 27),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
    ])

    subtitleLabel.font = Font.medium(16)
    subtitleLabel.textColor = .blueGray

    addSubview(subtitleLabel)
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subtitleLabel.leadingAnchor.constraint(equalTo: partnerLogoImageView.trailingAnchor, constant: 27),
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
    ])
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Internal

  struct Style: Hashable {

  }

  // MARK: ContentConfigurableView

  typealias Content = HorizontalPartnerViewViewModel

  func setContent(_ content: Content, animated: Bool) {
    partnerLogoImageView.loadBottle(url: content.imageURL)
    titleLabel.text = content.titleText
    subtitleLabel.text = content.subtitleText
  }

  // MARK: Private

  private let partnerLogoImageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
}

// MARK: HighlightableView

extension HorizontalPartnerView: HighlightableView {
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
