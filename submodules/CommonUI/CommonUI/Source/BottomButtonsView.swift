//
//  BottomButtonsView.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 11.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public protocol BottomButtonsViewDelegate: AnyObject {
  func didTapLeadingButton(_ button: UIButton)
  func didTapTrailingButton(_ button: UIButton)
}

public struct BottomButtonsViewModel: ViewModelProtocol {

  fileprivate let leadingButtonText: String?
  fileprivate let trailingButtonText: String?

  public init(leadingButtonText: String?, trailingButtonText: String?) {
    self.leadingButtonText = leadingButtonText
    self.trailingButtonText = trailingButtonText
  }
}

public final class BottomButtonsView: UIView {

  public weak var delegate: BottomButtonsViewDelegate?

  private lazy var leadingButton: UIButton = {
    let button = UIButton()
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
    stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    stackView.isLayoutMarginsRelativeArrangement = true

    return stackView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .mainBackground

    let line = UIView()
    line.translatesAutoresizingMaskIntoConstraints = false
    line.backgroundColor = .blueGray
    addSubview(line)
    line.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      line.topAnchor.constraint(equalTo: topAnchor),
      line.leadingAnchor.constraint(equalTo: leadingAnchor),
      line.trailingAnchor.constraint(equalTo: trailingAnchor),
      line.heightAnchor.constraint(equalToConstant: 0.3),
    ])

    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) { fatalError() }

  @objc
  private func didTapLeadingButton(_ button: UIButton) {
    delegate?.didTapLeadingButton(button)
  }

  @objc
  private func didTapTrailingButton(_ button: UIButton) {
    delegate?.didTapTrailingButton(button)
  }
}

extension BottomButtonsView: Decoratable {

  public typealias ViewModel = BottomButtonsViewModel

  public func decorate(model: ViewModel) {
    leadingButton.setTitle(model.leadingButtonText, for: .normal)
    trailingButton.setTitle(model.trailingButtonText, for: .normal)
  }
}
