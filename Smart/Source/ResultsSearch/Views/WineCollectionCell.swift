//
//  WineCollectionCell.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - WineCollectionCellViewModel

public struct WineCollectionCellViewModel: ViewModelProtocol {

  let wineID: Int64
  let imageURL: URL?
  let titleText: String
  let subtitleText: String?

  public init(wineID: Int64, imageURL: URL?, titleText: String, subtitleText: String?) {
    self.wineID = wineID
    self.imageURL = imageURL
    self.titleText = titleText
    self.subtitleText = subtitleText
  }
}

// MARK: - WineCollectionCell

class WineCollectionCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    bottleImageView.contentMode = .scaleAspectFit

    addSubview(bottleImageView)
    bottleImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottleImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 15),
      bottleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      bottleImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -15),
      bottleImageView.heightAnchor.constraint(equalToConstant: 100),
      bottleImageView.widthAnchor.constraint(equalToConstant: 40),
      bottleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
    ])

    titleLabel.font = Font.bold(24)
    titleLabel.numberOfLines = 2

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: bottleImageView.trailingAnchor, constant: 27),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
    ])

    subtitleLabel.font = Font.medium(16)
    subtitleLabel.textColor = .blueGray

    addSubview(subtitleLabel)
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subtitleLabel.leadingAnchor.constraint(equalTo: bottleImageView.trailingAnchor, constant: 27),
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Private

  private let bottleImageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
}

// MARK: Decoratable

extension WineCollectionCell: Decoratable {

  typealias ViewModel = WineCollectionCellViewModel

  internal func decorate(model: ViewModel) {
    bottleImageView.loadBottle(url: model.imageURL)
    titleLabel.text = model.titleText
    subtitleLabel.text = model.subtitleText
  }

}
