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
  fileprivate let scheduleOfWorkText: String?

  public init(
    affiliatedStoreId: Int,
    imageURL: URL?,
    titleText: String,
    subtitleText: String?,
    scheduleOfWorkText: String?)
  {
    self.affiliatedStoreId = affiliatedStoreId
    self.imageURL = imageURL
    self.titleText = titleText
    self.subtitleText = subtitleText
    self.scheduleOfWorkText = scheduleOfWorkText
  }
}

// MARK: - HorizontalPartnerView

final class HorizontalPartnerView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    background.backgroundColor = .option
    background.layer.cornerRadius = 20
    background.layer.masksToBounds = true

    addSubview(background)
    background.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      background.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      background.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      background.bottomAnchor.constraint(equalTo: bottomAnchor),
      background.topAnchor.constraint(equalTo: topAnchor),
    ])

    partnerLogoImageView.contentMode = .scaleAspectFill
    partnerLogoImageView.clipsToBounds = true
    partnerLogoImageView.layer.cornerRadius = 20
    background.addSubview(partnerLogoImageView)
    partnerLogoImageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      partnerLogoImageView.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
      partnerLogoImageView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10),
      partnerLogoImageView.widthAnchor.constraint(equalTo: partnerLogoImageView.heightAnchor),
      partnerLogoImageView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
    ])
    titleLabel.font = Font.bold(20)
    titleLabel.numberOfLines = 2

    subtitleLabel.font = Font.medium(16)
    subtitleLabel.textColor = .blueGray
    subtitleLabel.numberOfLines = 2

    scheduleOfWorkTitle.font = Font.light(16)
    scheduleOfWorkTitle.textColor = .dark
    scheduleOfWorkTitle.numberOfLines = 2

    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(subtitleLabel)
    stackView.addArrangedSubview(scheduleOfWorkTitle)
    stackView.addArrangedSubview(UIView())
    stackView.alignment = .top
    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.translatesAutoresizingMaskIntoConstraints = false
    background.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
      stackView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10),
      stackView.leadingAnchor.constraint(equalTo: partnerLogoImageView.trailingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

  }

  // MARK: ContentConfigurableView

  typealias Content = HorizontalPartnerViewViewModel

  func setContent(_ content: Content, animated: Bool) {
    partnerLogoImageView.loadBottle(url: content.imageURL)
    titleLabel.text = content.titleText
    subtitleLabel.text = content.subtitleText
    scheduleOfWorkTitle.text = content.scheduleOfWorkText
  }

  // MARK: Private

  private let partnerLogoImageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let background = UIView()
  private let scheduleOfWorkTitle = UILabel()
  private let stackView = UIStackView()
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
