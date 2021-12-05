//
//  StarRatingControlView .swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/8/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import EpoxyCore
import UIKit

// MARK: - StarRatingControlCollectionCellDelegate

public protocol StarRatingControlCollectionCellDelegate: AnyObject {
  func didTapStarRatingControl()
}

// MARK: - StarRatingControlCollectionViewCellViewModel

public struct StarRatingControlCollectionViewCellViewModel: ViewModelProtocol, Equatable {

  fileprivate let rate: Double
  fileprivate let count: Int

  public init(rate: Double, count: Int) {
    self.rate = rate
    self.count = count
  }
}

// MARK: - StarRatingControlView

public final class StarRatingControlView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.alignment = .center
    hStack.spacing = 6

    if style.kind == .small {
      rateLabel.font = Font.with(size: 24, design: .round, traits: .bold)
      ratingView.settings.starSize = 22
    } else {
      rateLabel.font = Font.with(size: 35, design: .round, traits: .bold)
      ratingView.settings.starSize = 32
    }

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

  // MARK: Public

  public struct Style: Hashable {
    public enum Kind {
      case small, normal
    }

    public let kind: Kind

    public init(kind: Kind) {
      self.kind = kind
    }
  }

  public typealias Content = StarRatingControlCollectionViewCellViewModel

  public static var height: CGFloat {
    32
  }

  public weak var delegate: StarRatingControlCollectionCellDelegate?

  public func setContent(_ content: Content, animated: Bool) {
    if content.rate != 0.0 {
      rateLabel.text = String(format: "%.1f", content.rate)
      rateLabel.isHidden = false
    } else {
      rateLabel.isHidden = true
    }

    if content.count != 0 {
      ratingView.text = "(" + String(content.count) + ")"
    } else {
      ratingView.text = nil
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
    $0.settings.filledBorderColor = .accent
    $0.settings.emptyBorderColor = .accent
    $0.settings.starSize = 32
    $0.settings.starMargin = 0
    $0.settings.updateOnTouch = false
    $0.settings.fillMode = .precise
    $0.settings.emptyBorderWidth = 1.0
    $0.settings.textFont = Font.regular(18)
    $0.settings.textColor = .blueGray
    return $0
  }(StarsRatingView())

  @objc
  private func didTapStarRatingControl() {
    delegate?.didTapStarRatingControl()
  }
}
