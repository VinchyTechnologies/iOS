//
//  RatingsAndReviewsCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - RatingsAndReviewsCellDelegate

protocol RatingsAndReviewsCellDelegate: AnyObject {
  func didTapSeeAllReview()
}

// MARK: - RatingsAndReviewsCellViewModel

struct RatingsAndReviewsCellViewModel: ViewModelProtocol {
  fileprivate let titleText: String?
  fileprivate let moreText: String?
  fileprivate let shouldShowMoreText: Bool

  init(titleText: String?, moreText: String?, shouldShowMoreText: Bool) {
    self.titleText = titleText
    self.moreText = moreText
    self.shouldShowMoreText = shouldShowMoreText
  }
}

// MARK: - RatingsAndReviewsCell

final class RatingsAndReviewsCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)

    moreButton.titleLabel?.font = Font.medium(16)
    moreButton.setTitleColor(.accent, for: .normal)
    moreButton.addTarget(self, action: #selector(didTapSeeAllButton(_:)), for: .touchUpInside)

    contentView.addSubview(moreButton)
    moreButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ])

    titleLabel.font = Font.heavy(20)
    titleLabel.textColor = .dark

    contentView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: -5),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  // MARK: - Internal Properties

  weak var delegate: RatingsAndReviewsCellDelegate?

  // MARK: Private

  // MARK: - Private Properties

  private let titleLabel = UILabel()
  private let moreButton = UIButton()

  @objc
  private func didTapSeeAllButton(_: UIButton) {
    delegate?.didTapSeeAllReview()
  }
}

// MARK: Decoratable

extension RatingsAndReviewsCell: Decoratable {
  typealias ViewModel = RatingsAndReviewsCellViewModel

  func decorate(model: ViewModel) {
    titleLabel.text = model.titleText
    moreButton.setTitle(model.moreText, for: .normal)
    moreButton.isHidden = !model.shouldShowMoreText
  }
}
