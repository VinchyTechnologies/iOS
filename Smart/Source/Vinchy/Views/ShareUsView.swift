//
//  ShareUsCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 07.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import EpoxyCore
import StringFormatting

// MARK: - ShareUsViewViewModel

public struct ShareUsViewViewModel: Equatable {
  fileprivate let titleText: String?

  public init(titleText: String?) {
    self.titleText = titleText
  }
}

// MARK: - ShareUsCollectionCellDelegate

protocol ShareUsCollectionCellDelegate: AnyObject {
  func didTapShareUs(_ button: UIButton)
}

// MARK: - ShareUsView

final class ShareUsView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)

    backgroundColor = .option

    layer.cornerRadius = 12
    clipsToBounds = true
    layer.masksToBounds = false

    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing

    titleLabel.font = Font.with(size: 24, design: .round, traits: .bold)
    titleLabel.textColor = .dark

    subtitleLabel.text = localized("tell_the_whole_world_about_us") // TODO: -
    subtitleLabel.font = Font.bold(18)
    subtitleLabel.textColor = .blueGray

    button.translatesAutoresizingMaskIntoConstraints = false
    button.heightAnchor.constraint(equalToConstant: 48).isActive = true
    button.widthAnchor.constraint(equalToConstant: 240).isActive = true // TODO: - adaptive
    button.setTitle(localized("share_link").firstLetterUppercased(), for: .normal)
    button.addTarget(self, action: #selector(didTapShareUs(_:)), for: .touchUpInside)

    [titleLabel, subtitleLabel].forEach { $0.numberOfLines = 0 }

    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(subtitleLabel)
    stackView.addArrangedSubview(button)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
  }

  typealias Content = ShareUsViewViewModel

  weak var delegate: ShareUsCollectionCellDelegate?

  func setContent(_ content: Content, animated: Bool) {
    titleLabel.text = content.titleText
  }

  @objc
  func didTapShareUs(_ button: UIButton) {
    delegate?.didTapShareUs(button)
  }

  // MARK: Private

  private let style: Style
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let button = Button()
}
