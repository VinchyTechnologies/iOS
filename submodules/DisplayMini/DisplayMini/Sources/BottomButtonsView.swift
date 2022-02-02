//
//  BottomButtonsView.swift
//  DisplayMini
//
//  Created by Aleksei Smirnov on 11.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import UIKit

// MARK: - BottomButtonsViewDelegate

public protocol BottomButtonsViewDelegate: AnyObject {
  func didTapLeadingButton(_ button: UIButton)
  func didTapTrailingButton(_ button: UIButton)
}

// MARK: - BottomButtonsViewModel

public struct BottomButtonsViewModel: ViewModelProtocol {
  fileprivate let leadingButtonText: String?
  fileprivate let trailingButtonText: String?

  public init(leadingButtonText: String?, trailingButtonText: String?) {
    self.leadingButtonText = leadingButtonText
    self.trailingButtonText = trailingButtonText
  }
}

// MARK: - BottomButtonsView

public final class BottomButtonsView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .mainBackground
    directionalLayoutMargins = .init(top: 12, leading: 24, bottom: 12, trailing: 24)

    let line = UIView()
    line.translatesAutoresizingMaskIntoConstraints = false
    line.backgroundColor = .separator
    addSubview(line)
    line.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      line.topAnchor.constraint(equalTo: topAnchor),
      line.leadingAnchor.constraint(equalTo: leadingAnchor),
      line.trailingAnchor.constraint(equalTo: trailingAnchor),
      line.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
    ])

    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.constrainToMarginsWithHighPriorityBottom()
    stackView.heightAnchor.constraint(equalToConstant: 48).isActive = true
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  public struct Style: Hashable {
    public init() {

    }
  }

  public struct Content: Equatable {
    fileprivate let leadingButtonText: String?
    fileprivate let trailingButtonText: String?

    public init(leadingButtonText: String?, trailingButtonText: String?) {
      self.leadingButtonText = leadingButtonText
      self.trailingButtonText = trailingButtonText
    }
  }

  public weak var delegate: BottomButtonsViewDelegate?

  public func setContent(_ content: Content, animated: Bool) {
    leadingButton.setTitle(content.leadingButtonText, for: .normal)
    trailingButton.setTitle(content.trailingButtonText, for: .normal)
  }

  // MARK: Private

  private lazy var leadingButton: UIButton = {
    let button = UIButton()
    button.startAnimatingPressActions()
    button.backgroundColor = .option
    button.setTitleColor(.blueGray, for: .normal)
    button.layer.cornerRadius = 16
    button.layer.cornerCurve = .continuous
    button.titleLabel?.font = Font.bold(18)
    button.addTarget(self, action: #selector(didTapLeadingButton(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var trailingButton: UIButton = {
    let button = UIButton()
    button.startAnimatingPressActions()
    button.backgroundColor = .accent
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 16
    button.layer.cornerCurve = .continuous
    button.titleLabel?.font = Font.bold(18)
    button.addTarget(self, action: #selector(didTapTrailingButton(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [leadingButton, trailingButton])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 16
    return stackView
  }()

  @objc
  private func didTapLeadingButton(_ button: UIButton) {
    delegate?.didTapLeadingButton(button)
  }

  @objc
  private func didTapTrailingButton(_ button: UIButton) {
    delegate?.didTapTrailingButton(button)
  }
}

// MARK: Decoratable

extension BottomButtonsView: Decoratable {
  public typealias ViewModel = BottomButtonsViewModel

  public func decorate(model: ViewModel) {
    leadingButton.setTitle(model.leadingButtonText, for: .normal)
    trailingButton.setTitle(model.trailingButtonText, for: .normal)
  }
}
