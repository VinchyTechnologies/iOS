//
//  EmptyView.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy
import UIKit

// MARK: - EmptyViewDelegate

public protocol EmptyViewDelegate: AnyObject {
  func didTapEmptyButton(_ button: UIButton)
}

// MARK: - EmptyViewModel

public struct EmptyViewModel: ViewModelProtocol, Equatable {
  fileprivate let titleText: String?
  fileprivate let subtitleText: String?
  fileprivate let buttonText: String?

  public init(titleText: String?, subtitleText: String?, buttonText: String?) {
    self.titleText = titleText
    self.subtitleText = subtitleText
    self.buttonText = buttonText
  }
}

// MARK: - EmptyView

public final class EmptyView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

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

  public struct Style: Hashable {

  }

  public typealias Content = EmptyViewModel

  public weak var delegate: EmptyViewDelegate?

  public func setContent(_ content: Content, animated: Bool) {
    titleLabel.text = content.titleText
    titleLabel.isHidden = content.titleText == nil

    subtitleLabel.text = content.subtitleText
    subtitleLabel.isHidden = content.subtitleText == nil

    button.setTitle(content.buttonText, for: .normal)
    button.isHidden = content.buttonText == nil
  }

  // MARK: Private

  private let style: Style
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let button = Button()

  @objc
  private func didTapErrorButton(_ button: UIButton) {
    delegate?.didTapEmptyButton(button)
  }
}
