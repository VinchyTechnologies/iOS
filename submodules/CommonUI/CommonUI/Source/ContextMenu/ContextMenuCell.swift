//
//  ContextMenuCell.swift
//  Smart
//
//  Created by Михаил Исаченко on 18.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

open class ContextMenuCell: UITableViewCell {

  // MARK: Lifecycle

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    let stackView = UIStackView(arrangedSubviews: [titleLabel, iconImageView])

    contentView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }

  @available(*, unavailable)
  required public init?(coder _: NSCoder) { fatalError() }

  // MARK: Open

  override open func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
    if highlighted {
      contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }else{
      contentView.backgroundColor = .clear
    }
  }

  override open func prepareForReuse() {
    super.prepareForReuse()

    titleLabel.text = nil
    iconImageView.image = nil
  }

  open func setup() {
    titleLabel.text = item.title
    if let menuConstants = style {
      titleLabel.font = menuConstants.LabelDefaultFont
    }
    iconImageView.image = item.image
    iconImageView.tintColor = UIColor.dark
    iconImageView.isHidden = item.image == nil
  }

  // MARK: Internal

  static let identifier = "ContextMenuCell"

  weak var contextMenu: ContextMenu?
  weak var tableView: UITableView?
  var item: ContextMenuItem!
  var style: ContextMenuConstants? = nil

  // MARK: Private

  private lazy var titleLabel: UILabel = {
    $0.font = Font.bold(14)
    return $0
  }(UILabel())

  private lazy var iconImageView: UIImageView = {
    $0.contentMode = .scaleAspectFit
    return $0
  }(UIImageView())

}
