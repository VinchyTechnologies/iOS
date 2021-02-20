//
//  RatingsAndReviewsCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

protocol RatingsAndReviewsCellDelegate: AnyObject {
  func didTapSeeAllReview()
}

struct RatingsAndReviewsCellViewModel: ViewModelProtocol {

  fileprivate let titleText: String?
  fileprivate let moreText: String?

  init(titleText: String?, moreText: String?) {
    self.titleText = titleText
    self.moreText = moreText
  }
}

final class RatingsAndReviewsCell: UICollectionViewCell, Reusable {

  // MARK: - Internal Properties

  weak var delegate: RatingsAndReviewsCellDelegate?

  // MARK: - Private Properties

  private let titleLabel = UILabel()
  private let moreButton = UIButton()

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

  required init?(coder: NSCoder) { fatalError() }

  @objc
  private func didTapSeeAllButton(_ button: UIButton) {
      delegate?.didTapSeeAllReview()
  }
}

extension RatingsAndReviewsCell: Decoratable {

  typealias ViewModel = RatingsAndReviewsCellViewModel

  func decorate(model: ViewModel) {
    titleLabel.text = model.titleText
    moreButton.setTitle(model.moreText, for: .normal)
  }
}
