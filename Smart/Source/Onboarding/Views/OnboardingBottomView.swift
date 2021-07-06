//
//  OnboardingBottomView.swift
//  Smart
//
//  Created by Алексей Смирнов on 25.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - OnboardingBottomViewDelegate

protocol OnboardingBottomViewDelegate: AnyObject {
  func didTapYellowButton(_ button: UIButton)
}

// MARK: - OnboardingBottomViewViewModel

struct OnboardingBottomViewViewModel: ViewModelProtocol {

  fileprivate let titleText: String?
  fileprivate let subtitleText: String?
  fileprivate let buttonText: String?

  init(titleText: String?, subtitleText: String?, buttonText: String?) {
    self.titleText = titleText
    self.subtitleText = subtitleText
    self.buttonText = buttonText
  }
}

// MARK: - OnboardingBottomView

final class OnboardingBottomView: UIView {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    clipsToBounds = true

    layer.cornerRadius = 30
    layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

    backgroundColor = .option

    let stackView = UIStackView()
    yellowButton.addTarget(self, action: #selector(didTapYellowButton(_:)), for: .touchUpInside)
    yellowButton.translatesAutoresizingMaskIntoConstraints = false
    yellowButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8).isActive = true
    yellowButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .equalCentering

    addSubview(stackView)

    titleLabel.minimumScaleFactor = 0.2
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.numberOfLines = 2
    titleLabel.font = .boldSystemFont(ofSize: 28)
    titleLabel.textAlignment = .center

    subtitleLabel.minimumScaleFactor = 0.2
    subtitleLabel.adjustsFontSizeToFitWidth = true
    subtitleLabel.numberOfLines = 0
    subtitleLabel.font = .systemFont(ofSize: 18)
    subtitleLabel.textColor = .blueGray
    subtitleLabel.textAlignment = .center
    subtitleLabel.baselineAdjustment = .alignCenters

    stackView.spacing = 5
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(subtitleLabel)
    stackView.addArrangedSubview(yellowButton)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
    ])
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Internal

  weak var delegate: OnboardingBottomViewDelegate?

  // MARK: Private

  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let yellowButton = Button()

  @objc
  private func didTapYellowButton(_ button: UIButton) {
    delegate?.didTapYellowButton(button)
  }

}

// MARK: Decoratable

extension OnboardingBottomView: Decoratable {
  typealias ViewModel = OnboardingBottomViewViewModel

  func decorate(model: ViewModel) {
    titleLabel.text = model.titleText
    subtitleLabel.text = model.subtitleText
    yellowButton.setTitle(model.buttonText, for: [])
  }
}
