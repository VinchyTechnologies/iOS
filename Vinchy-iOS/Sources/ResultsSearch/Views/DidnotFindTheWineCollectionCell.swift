//
//  DidnotFindTheWineCollectionCell.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import EpoxyCore
import StringFormatting
import UIKit
import WineDetail

// MARK: - DidnotFindTheWineCollectionCellProtocol

protocol DidnotFindTheWineCollectionCellProtocol: AnyObject {
  func didTapWriteUsButton(_ button: UIButton)
}

// MARK: - DidnotFindTheWineView

final class DidnotFindTheWineView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    directionalLayoutMargins = .zero
    translatesAutoresizingMaskIntoConstraints = false

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

    addSubview(writeUsButton)
    NSLayoutConstraint.activate([
      writeUsButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      writeUsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      writeUsButton.heightAnchor.constraint(equalToConstant: 44),
      writeUsButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
    ])

    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: writeUsButton.leadingAnchor, constant: -10),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

  }

  struct Content: Equatable {
    fileprivate let titleText: String
    fileprivate let writeUsButtonText: String?

    public init(titleText: String, writeUsButtonText: String?) {
      self.titleText = titleText
      self.writeUsButtonText = writeUsButtonText
    }
  }

  weak var delegate: DidnotFindTheWineCollectionCellProtocol?

  func setContent(_ content: Content, animated: Bool) {
    titleLabel.text = content.titleText
    writeUsButton.setTitle(content.writeUsButtonText, for: .normal)
  }

  // MARK: Private

  private let titleLabel = UILabel()
  private let writeUsButton = UIButton()

  @objc
  private func didTapWriteUsButton(_ button: UIButton) {
    delegate?.didTapWriteUsButton(button)
  }
}
