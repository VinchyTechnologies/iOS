//
//  StoreTitleCollectionCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 13.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - StoreTitleCollectionCellDelegate

protocol StoreTitleCollectionCellDelegate: AnyObject {
  func didTapSeeAllStore(affilatedId: Int)
}

// MARK: - StoreTitleCollectionCellViewModel

struct StoreTitleCollectionCellViewModel: ViewModelProtocol {

  let affilatedId: Int?
  fileprivate let imageURL: String?
  fileprivate let titleText: String?
  fileprivate let moreText: String?

  init(affilatedId: Int?, imageURL: String?, titleText: String?, moreText: String?) {
    self.affilatedId = affilatedId
    self.imageURL = imageURL
    self.titleText = titleText
    self.moreText = moreText
  }
}

// MARK: - StoreTitleCollectionCell

final class StoreTitleCollectionCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

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

    contentView.addSubview(hStackView)
    hStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      hStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      hStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      hStackView.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: -8),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  weak var delegate: StoreTitleCollectionCellDelegate?

  static func height(viewModel: ViewModel?, for width: CGFloat) -> CGFloat {

    guard let viewModel = viewModel else {
      return 0
    }

    let width = width - (viewModel.imageURL == nil ? 0 : 48 + 8) - (viewModel.moreText?.width(usingFont: Font.medium(16)) ?? 0) + 8
    let height = viewModel.titleText?.height(forWidth: width, font: Font.heavy(20), numberOfLines: 0) ?? 0
    return max(48, height)
  }

  // MARK: Private

  private var affilatedId: Int?
  private lazy var hStackView: UIStackView = {
    $0.axis = .horizontal
    $0.spacing = 8
    return $0
  }(UIStackView(arrangedSubviews: [imageView, titleLabel]))

  private let titleLabel: UILabel = {
    $0.font = Font.heavy(20)
    $0.numberOfLines = 0
    $0.textColor = .dark
    return $0
  }(UILabel())

  private let imageView: UIImageView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      $0.widthAnchor.constraint(equalToConstant: 48),
      $0.heightAnchor.constraint(equalToConstant: 48),
    ])
    $0.layer.cornerRadius = 24
    $0.clipsToBounds = true
    $0.layer.borderColor = UIColor.option.cgColor
    $0.layer.borderWidth = 1 / UIScreen.main.scale
    return $0
  }(UIImageView())

  private lazy var moreButton: UIButton = {
    $0
  }(UIButton(type: .system))

  @objc
  private func didTapSeeAllButton(_: UIButton) {
    if let affilatedId = affilatedId {
      delegate?.didTapSeeAllStore(affilatedId: affilatedId)
    }
  }

}

// MARK: Decoratable

extension StoreTitleCollectionCell: Decoratable {

  typealias ViewModel = StoreTitleCollectionCellViewModel

  func decorate(model: ViewModel) {
    affilatedId = model.affilatedId
    imageView.loadImage(url: model.imageURL?.toURL)
    imageView.isHidden = model.imageURL == nil
    titleLabel.text = model.titleText
    moreButton.setTitle(model.moreText, for: [])
  }
}
