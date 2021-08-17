//
//  DidnotFindTheWineTableCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 19.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import StringFormatting
import UIKit

// MARK: - DidnotFindTheWineTableCellProtocol

protocol DidnotFindTheWineTableCellProtocol: AnyObject {
  func didTapWriteUsButton(_ button: UIButton)
}

// MARK: - DidnotFindTheWineTableCell

final class DidnotFindTheWineTableCell: UITableViewCell, Reusable {

  // MARK: Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    selectionStyle = .none
    backgroundColor = .mainBackground

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = localized("did_not_find_the_wine")
    titleLabel.font = Font.bold(16)
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.minimumScaleFactor = 0.8

    writeUsButton.translatesAutoresizingMaskIntoConstraints = false
    writeUsButton.backgroundColor = .accent
    writeUsButton.setTitle(localized("write_us").firstLetterUppercased(), for: .normal)
    writeUsButton.setTitleColor(.white, for: .normal)
    writeUsButton.contentEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16)
    writeUsButton.layer.cornerRadius = 10
    writeUsButton.clipsToBounds = true
    writeUsButton.titleLabel?.font = Font.bold(14)
    writeUsButton.addTarget(self, action: #selector(didTapWriteUsButton(_:)), for: .touchUpInside)

    contentView.addSubview(writeUsButton)
    NSLayoutConstraint.activate([
      writeUsButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      writeUsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      writeUsButton.heightAnchor.constraint(equalToConstant: 44),
      writeUsButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
    ])

    contentView.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: writeUsButton.leadingAnchor, constant: -10),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  weak var delegate: DidnotFindTheWineTableCellProtocol?

  // MARK: Private

  private let titleLabel = UILabel()
  private let writeUsButton = UIButton()

  @objc
  private func didTapWriteUsButton(_ button: UIButton) {
    delegate?.didTapWriteUsButton(button)
  }
}
