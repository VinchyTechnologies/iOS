//
//  RoutingToolBar.swift
//  Smart
//
//  Created by Алексей Смирнов on 27.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - RoutingToolBarDelegate

protocol RoutingToolBarDelegate: AnyObject {
  func didTapXMarkButton(_ button: UIButton)
  func didTapOpenInAppButton(_ button: UIButton)
}

// MARK: - RoutingToolBarViewModel

struct RoutingToolBarViewModel: ViewModelProtocol {
  fileprivate let distanceText: NSAttributedString?

  init(distanceText: NSAttributedString?) {
    self.distanceText = distanceText
  }
}

// MARK: - RoutingToolBar

final class RoutingToolBar: UIView {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .mainBackground

    addSubview(appsButton)
    appsButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      appsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      appsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      appsButton.widthAnchor.constraint(equalToConstant: 24),
      appsButton.heightAnchor.constraint(equalToConstant: 24),
    ])

    addSubview(xMarkButton)
    xMarkButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      xMarkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      xMarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      xMarkButton.widthAnchor.constraint(equalToConstant: 24),
      xMarkButton.heightAnchor.constraint(equalToConstant: 24),
    ])

    addSubview(distanceLabel)
    distanceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      distanceLabel.topAnchor.constraint(equalTo: topAnchor),
      distanceLabel.leadingAnchor.constraint(equalTo: appsButton.trailingAnchor, constant: 10),
      distanceLabel.trailingAnchor.constraint(equalTo: xMarkButton.leadingAnchor, constant: -10),
      distanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  weak var delegate: RoutingToolBarDelegate?

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height / 2
  }

  // MARK: Private

  private lazy var appsButton: UIButton = {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)
    $0.setImage(UIImage(systemName: "arrow.up.right.square", withConfiguration: imageConfig), for: .normal)
    $0.tintColor = .dark
    $0.addTarget(self, action: #selector(didTapOpenInAppButton(_:)), for: .touchUpInside)
    return $0
  }(UIButton())

  private lazy var xMarkButton: UIButton = {
    $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
    $0.tintColor = .dark
    $0.addTarget(self, action: #selector(didTapXMarkButton(_:)), for: .touchUpInside)
    return $0
  }(UIButton())

  private lazy var distanceLabel: UILabel = {
    $0.font = Font.bold(20)
    $0.textColor = .dark
    $0.textAlignment = .center
    return $0
  }(UILabel())

  @objc
  private func didTapOpenInAppButton(_ button: UIButton) {
    delegate?.didTapOpenInAppButton(button)
  }

  @objc
  private func didTapXMarkButton(_ button: UIButton) {
    delegate?.didTapXMarkButton(button)
  }
}

// MARK: Decoratable

extension RoutingToolBar: Decoratable {
  typealias ViewModel = RoutingToolBarViewModel

  func decorate(model: ViewModel) {
    distanceLabel.attributedText = model.distanceText
  }
}
