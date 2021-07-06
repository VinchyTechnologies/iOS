//
//  FeaturesOnboardingViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

final class FeaturesOnboardingViewController: UIViewController {

  // MARK: Internal

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    let xMarkButton = UIButton(type: .system)
    xMarkButton.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfig), for: [])
    xMarkButton.tintColor = .dark
    view.addSubview(xMarkButton)
    xMarkButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      xMarkButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
      xMarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      xMarkButton.widthAnchor.constraint(equalToConstant: 36),
      xMarkButton.heightAnchor.constraint(equalToConstant: 36),
    ])

    view.addSubview(continueButton)
    continueButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      continueButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8),
      continueButton.heightAnchor.constraint(equalToConstant: 48),
      continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])

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

    view.addSubview(vStackView)
    vStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      vStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
      vStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
      vStackView.bottomAnchor.constraint(lessThanOrEqualTo: continueButton.topAnchor, constant: -24),
    ])
  }

  // MARK: Private

  private lazy var continueButton: Button = {
    $0.setTitle("Дальше", for: [])
    return $0
  }(Button())
}
