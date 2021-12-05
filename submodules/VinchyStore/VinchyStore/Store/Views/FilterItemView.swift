//
//  FilterItemView.swift
//  Smart
//
//  Created by Алексей Смирнов on 10.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import EpoxyCollectionView
import EpoxyCore

// MARK: - FilterItemViewViewModel

struct FilterItemViewViewModel: Equatable {
  fileprivate let titleText: String?

  init(titleText: String?) {
    self.titleText = titleText
  }
}

// MARK: - FilterItemView

typealias FilterItemViewItem = SupplementaryItemModel<FilterItemView>

// MARK: - FilterItemView

final class FilterItemView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    backgroundColor = .accent

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
    ])
  }
  required init?(coder: NSCoder) { fatalError() }

  // MARK: Internal

  struct Style: Hashable {

  }

  // MARK: ContentConfigurableView

  typealias Content = String

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height / 2
    clipsToBounds = true
  }

  func setContent(_ content: Content, animated: Bool) {
    titleLabel.text = content
  }

  // MARK: Private

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = Font.semibold(16)
    label.textAlignment = .center
    return label
  }()
}
