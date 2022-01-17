//
//  DidnotFindTheWineCollectionCell.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import StringFormatting
import UIKit

// MARK: - DidnotFindTheWineCollectionCellViewModel

public struct DidnotFindTheWineCollectionCellViewModel: ViewModelProtocol {

  fileprivate let titleText: String
  fileprivate let writeUsButtonText: String?

  public init(titleText: String, writeUsButtonText: String?) {
    self.titleText = titleText
    self.writeUsButtonText = writeUsButtonText
  }
}

// MARK: - DidnotFindTheWineCollectionCellProtocol

protocol DidnotFindTheWineCollectionCellProtocol: AnyObject {
  func didTapWriteUsButton(_ button: UIButton)
}

// MARK: - DidnotFindTheWineCollectionCell

final class DidnotFindTheWineCollectionCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = Font.bold(16)
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.minimumScaleFactor = 0.8

    writeUsButton.translatesAutoresizingMaskIntoConstraints = false
    writeUsButton.backgroundColor = .accent
    writeUsButton.setTitleColor(.white, for: .normal)
    writeUsButton.contentEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16)
    writeUsButton.layer.cornerRadius = 10
    writeUsButton.clipsToBounds = true
    writeUsButton.titleLabel?.font = Font.bold(14)
    writeUsButton.addTarget(self, action: #selector(didTapWriteUsButton(_:)), for: .touchUpInside)

    contentView.addSubview(writeUsButton)
    NSLayoutConstraint.activate([
      writeUsButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      writeUsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      writeUsButton.heightAnchor.constraint(equalToConstant: 44),
      writeUsButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
    ])

    contentView.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: writeUsButton.leadingAnchor, constant: -10),
    ])
  }
  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  weak var delegate: DidnotFindTheWineCollectionCellProtocol?

  // MARK: Private

  private let titleLabel = UILabel()
  private let writeUsButton = UIButton()

  @objc
  private func didTapWriteUsButton(_ button: UIButton) {
    delegate?.didTapWriteUsButton(button)
  }
}

// MARK: Decoratable

extension DidnotFindTheWineCollectionCell: Decoratable {

  typealias ViewModel = DidnotFindTheWineCollectionCellViewModel

  internal func decorate(model: ViewModel) {
    titleLabel.text = model.titleText
    writeUsButton.setTitle(model.writeUsButtonText, for: .normal)
  }
}
