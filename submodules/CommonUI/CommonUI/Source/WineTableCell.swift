//
//  WineTableCell.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - WineTableCellViewModel

public struct WineTableCellViewModel: ViewModelProtocol {

  public let wineID: Int64
  fileprivate let imageURL: URL?
  fileprivate let titleText: String
  fileprivate let subtitleText: String?

  public init(wineID: Int64, imageURL: URL?, titleText: String, subtitleText: String?) {
    self.wineID = wineID
    self.imageURL = imageURL
    self.titleText = titleText
    self.subtitleText = subtitleText
  }
}

// MARK: - WineTableCell

public final class WineTableCell: UITableViewCell, Reusable {

  // MARK: Lifecycle

  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .mainBackground

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

extension WineTableCell: Decoratable {
  public typealias ViewModel = WineTableCellViewModel

  public func decorate(model: ViewModel) {
    bottleImageView.loadBottle(url: model.imageURL)
    titleLabel.text = model.titleText
    subtitleLabel.text = model.subtitleText
  }
}
