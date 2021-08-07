//
//  StarRatingControlView .swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/8/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import Epoxy
import UIKit

// MARK: - StarRatingControlCollectionCellDelegate

protocol StarRatingControlCollectionCellDelegate: AnyObject {
  func didTapStarRatingControl()
}

// MARK: - StarRatingControlCollectionViewCellViewModel

struct StarRatingControlCollectionViewCellViewModel: ViewModelProtocol, Equatable {

  fileprivate let rate: Double

  init(rate: Double) {
    self.rate = rate
  }
}

// MARK: - StarRatingControlView

final class StarRatingControlView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.alignment = .center
    hStack.spacing = 6

    hStack.addArrangedSubview(rateLabel)
    hStack.addArrangedSubview(ratingView)
    hStack.addArrangedSubview(UIView())

    hStack.translatesAutoresizingMaskIntoConstraints = false
    addSubview(hStack)
    NSLayoutConstraint.activate([
      hStack.topAnchor.constraint(equalTo: topAnchor),
      hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
      hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
      hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])

    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapStarRatingControl))
    addGestureRecognizer(tap)

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

  }

  typealias Content = StarRatingControlCollectionViewCellViewModel

  static var height: CGFloat {
    32
  }

  weak var delegate: StarRatingControlCollectionCellDelegate?

  func setContent(_ content: Content, animated: Bool) {
    if content.rate != 0.0 {
      rateLabel.text = String(format: "%.1f", content.rate)
      rateLabel.isHidden = false
    } else {
      rateLabel.isHidden = true
    }
    ratingView.rating = content.rate
  }

  // MARK: Private

  private let style: Style
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
    $0.settings.emptyBorderWidth = 1.0
    return $0
  }(StarsRatingView())

  @objc
  private func didTapStarRatingControl() {
    delegate?.didTapStarRatingControl()
  }
}
