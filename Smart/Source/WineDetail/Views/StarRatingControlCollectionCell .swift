//
//  StarRatingControlCollectionCell .swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/8/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import UIKit

// MARK: - StarRatingControlCollectionCellDelegate

protocol StarRatingControlCollectionCellDelegate: AnyObject {
  func didTapStarRatingControl()
}

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

    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.alignment = .center
    hStack.spacing = 6

    hStack.addArrangedSubview(rateLabel)
    hStack.addArrangedSubview(ratingView)
    hStack.addArrangedSubview(UIView())

    hStack.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(hStack)
    NSLayoutConstraint.activate([
      hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
      hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])

    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapStarRatingControl))
    addGestureRecognizer(tap)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  weak var delegate: StarRatingControlCollectionCellDelegate?

  // MARK: Private

  private let rateLabel: UILabel = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Font.with(size: 35, design: .round, traits: .bold)
    $0.textColor = .dark
    return $0
  }(UILabel())

  private lazy var ratingView: StarsRatingView = {
    $0.settings.filledColor = .accent
    $0.settings.emptyBorderColor = .accent
    $0.settings.starSize = 32
    $0.settings.starMargin = 0
    $0.settings.updateOnTouch = false
    $0.settings.fillMode = .precise
    return $0
  }(StarsRatingView())

  @objc
  private func didTapStarRatingControl() {
    delegate?.didTapStarRatingControl()
  }
}

// MARK: Decoratable

extension StarRatingControlCollectionCell: Decoratable {
  typealias ViewModel = StarRatingControlCollectionViewCellViewModel

  func decorate(model: ViewModel) {
    if model.rate != 0.0 {
      rateLabel.text = String(format: "%.1f", model.rate)
      rateLabel.isHidden = false
    } else {
      rateLabel.isHidden = true
    }
    ratingView.rating = model.rate
  }
}
