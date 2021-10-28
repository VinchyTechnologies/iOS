//
//  EpoxyErrorView.swift
//  Smart
//
//  Created by Алексей Смирнов on 28.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy

// MARK: - EpoxyErrorViewDelegate

public protocol EpoxyErrorViewDelegate: AnyObject {
  func didTapErrorButton(_ button: UIButton)
}

// MARK: - EpoxyErrorView

final class EpoxyErrorView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)

    let spacer1 = UIView()

    let views = [
      titleLabel,
      subtitleLabel,
      spacer1,
      button,
    ]

    views.forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    titleLabel.font = Font.bold(24)
    titleLabel.textAlignment = .center
    titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 40).isActive = true

    subtitleLabel.font = Font.medium(18)
    subtitleLabel.textColor = .blueGray
    subtitleLabel.textAlignment = .center
    subtitleLabel.numberOfLines = 3
    subtitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 40).isActive = true

    button.heightAnchor.constraint(equalToConstant: 48).isActive = true
    button.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
    button.addTarget(self, action: #selector(didTapErrorButton(_:)), for: .touchUpInside)

    spacer1.heightAnchor.constraint(equalToConstant: 5).isActive = true

    let stackView = UIStackView(arrangedSubviews: views)
    stackView.axis = .vertical

    stackView.distribution = .equalCentering
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public weak var delegate: EpoxyErrorViewDelegate?

  // MARK: Internal

  struct Style: Hashable {

  }

  struct Content: Equatable {
    let titleText: String?
    let subtitleText: String?
    let buttonText: String?
  }


  func setContent(_ content: Content, animated: Bool) {
    titleLabel.text = content.titleText
    titleLabel.isHidden = content.titleText == nil

    subtitleLabel.text = content.subtitleText
    subtitleLabel.isHidden = content.subtitleText == nil

    button.setTitle(content.buttonText, for: .normal)
    button.isHidden = content.buttonText == nil
  }

  // MARK: Private

  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let button = Button()


  @objc
  private func didTapErrorButton(_ button: UIButton) {
    delegate?.didTapErrorButton(button)
  }
}
