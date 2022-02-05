//
//  SeparatorCell.swift
//  DisplayMini
//
//  Created by Алексей Смирнов on 25.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit // TODO: - move to Display

public final class SeparatorCell: UICollectionViewCell, Reusable {
  override public init(frame: CGRect) {
    super.init(frame: frame)

    let line = UIView()
    line.backgroundColor = .separator

    contentView.addSubview(line)
    line.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      line.heightAnchor.constraint(equalToConstant: 0.8),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }
}
