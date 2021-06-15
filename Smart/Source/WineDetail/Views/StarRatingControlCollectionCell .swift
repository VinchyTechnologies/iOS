//
//  StarRatingControlCollectionCell .swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/8/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Cosmos
import Display
import UIKit

// MARK: - StarRatingControlCollectionViewCellViewModel

struct StarRatingControlCollectionViewCellViewModel: ViewModelProtocol {
  fileprivate let rate: Double

  init(rate: Double) {
    self.rate = rate
  }
}

// MARK: - StarRatingControlCollectionCell

final class StarRatingControlCollectionCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(rateLabel)
    rateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      rateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      rateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      rateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])

    contentView.addSubview(ratingView)
    ratingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingView.leadingAnchor.constraint(equalTo: rateLabel.trailingAnchor, constant: 6),
      ratingView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
      ratingView.centerYAnchor.constraint(equalTo: rateLabel.centerYAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Private

  private let rateLabel: UILabel = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Font.with(size: 35, design: .round, traits: .bold)
    $0.textColor = .dark
    return $0
  }(UILabel())

  private lazy var ratingView: CosmosView = {
    $0.settings.filledColor = .accent
    $0.settings.emptyBorderColor = .accent
    $0.settings.starSize = 32
    $0.settings.starMargin = 0
    $0.settings.updateOnTouch = false
    $0.settings.fillMode = .precise
    return $0
  }(CosmosView())
}

// MARK: Decoratable

extension StarRatingControlCollectionCell: Decoratable {
  typealias ViewModel = StarRatingControlCollectionViewCellViewModel

  func decorate(model: ViewModel) {
    rateLabel.text = String(format: "%.1f", model.rate)
    ratingView.rating = model.rate
  }
}
