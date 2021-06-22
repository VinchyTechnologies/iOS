//
//  TapToRateCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import UIKit

// MARK: - TapToRateCellViewModel

struct TapToRateCellViewModel: ViewModelProtocol {
  fileprivate let titleText: String?
  fileprivate let rate: Double?

  init(titleText: String?, rate: Double?) {
    self.titleText = titleText
    self.rate = rate
  }
}

// MARK: - TapToRateCell

final class TapToRateCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ])

    contentView.addSubview(ratingView)
    ratingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      ratingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Private

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Font.regular(18)
    label.textColor = .blueGray
    return label
  }()

  private lazy var ratingView: StarsRatingView = {
    let view = StarsRatingView()
    view.settings.filledColor = .accent
    view.settings.emptyBorderColor = .accent
    view.settings.starSize = 32
    view.settings.fillMode = .half
    view.settings.minTouchRating = 0
    view.rating = 4.5
    view.settings.starMargin = 10
    return view
  }()
}

// MARK: Decoratable

extension TapToRateCell: Decoratable {
  typealias ViewModel = TapToRateCellViewModel

  func decorate(model: ViewModel) {
    titleLabel.text = model.titleText
    ratingView.rating = model.rate ?? 0
  }
}
