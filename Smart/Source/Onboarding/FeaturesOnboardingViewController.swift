//
//  FeaturesOnboardingViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

final class FeaturesOnboardingViewController: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .mainBackground

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    let xMarkButton = UIButton(type: .system)
    xMarkButton.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfig), for: [])
    xMarkButton.tintColor = .dark
    addSubview(xMarkButton)
    xMarkButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      xMarkButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
      xMarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      xMarkButton.widthAnchor.constraint(equalToConstant: 36),
      xMarkButton.heightAnchor.constraint(equalToConstant: 36),
    ])

    xMarkButton.addTarget(self, action: #selector(didTapCloseSelf), for: .touchUpInside)

    addSubview(continueButton)
    continueButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
      continueButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8),
      continueButton.heightAnchor.constraint(equalToConstant: 48),
      continueButton.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])
    continueButton.addTarget(self, action: #selector(didTapNexButton), for: .touchUpInside)

    let page1 = OnboardingFeatureView()
    page1.decorate(model: .init(style: .bottles))

    let page2 = OnboardingFeatureView()
    page2.decorate(model: .init(style: .geo))

    let page3 = OnboardingFeatureView()
    page3.decorate(model: .init(style: .rating))

    let vStackView = UIStackView(arrangedSubviews: [
      page1,
      page2,
      page3,
    ])

    vStackView.axis = .vertical
    vStackView.distribution = .equalSpacing
    vStackView.spacing = 40
    vStackView.alignment = .center

    addSubview(vStackView)
    vStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      vStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      vStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
      vStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24),
      vStackView.bottomAnchor.constraint(lessThanOrEqualTo: continueButton.topAnchor, constant: -24),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  weak var delegate: OnboardingPageDelegate?

  // MARK: Private

  private lazy var continueButton: Button = {
    $0.setTitle("Дальше", for: [])
    return $0
  }(Button())

  @objc
  private func didTapCloseSelf() {
    delegate?.didTapCloseButton()
  }

  @objc
  private func didTapNexButton() {
    delegate?.didTapNexButton()
  }
}
