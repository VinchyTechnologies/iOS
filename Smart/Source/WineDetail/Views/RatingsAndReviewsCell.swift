//
//  RatingsAndReviewsCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy
import UIKit

// MARK: - TitleAndMoreViewDelegate

protocol TitleAndMoreViewDelegate: AnyObject {
  func didTapSeeAllReview()
}

// MARK: - TitleAndMoreViewViewModel

struct TitleAndMoreViewViewModel: ViewModelProtocol, Equatable {
  fileprivate let titleText: String?
  fileprivate let moreText: String?
  fileprivate let shouldShowMoreText: Bool

  init(titleText: String?, moreText: String?, shouldShowMoreText: Bool) {
    self.titleText = titleText
    self.moreText = moreText
    self.shouldShowMoreText = shouldShowMoreText
  }
}

// MARK: - TitleAndMoreView

final class TitleAndMoreView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    moreButton.titleLabel?.font = Font.medium(16)
    moreButton.setTitleColor(.accent, for: .normal)
    moreButton.addTarget(self, action: #selector(didTapSeeAllButton(_:)), for: .touchUpInside)

    addSubview(moreButton)
    moreButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      moreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])

    titleLabel.font = Font.heavy(20)
    titleLabel.textColor = .dark

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: -5),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
  }

  typealias Content = TitleAndMoreViewViewModel

  weak var delegate: TitleAndMoreViewDelegate?

  static func height(width: CGFloat, content: Content) -> CGFloat {
    let buttonWidth = content.moreText?.width(usingFont: Font.medium(16)) ?? 0
    let titleWidth = width - buttonWidth - 5
    return content.titleText?.height(forWidth: titleWidth, font: Font.heavy(20)) ?? 0
  }

  func setContent(_ content: Content, animated: Bool) {
    titleLabel.text = content.titleText
    moreButton.setTitle(content.moreText, for: .normal)
    moreButton.isHidden = !content.shouldShowMoreText
  }

  // MARK: Private

  private let style: Style
  private let titleLabel = UILabel()
  private let moreButton = UIButton()

  @objc
  private func didTapSeeAllButton(_: UIButton) {
    delegate?.didTapSeeAllReview()
  }
}
