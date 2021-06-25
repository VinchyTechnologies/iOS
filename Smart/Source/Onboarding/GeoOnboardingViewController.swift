//
//  GeoOnboardingViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 25.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class GeoOnboardingViewController: UIViewController {

  // MARK: Internal

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground

    view.addSubview(bottomView)
    bottomView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomView.heightAnchor.constraint(equalToConstant: 325),
    ])

    let topView = UIView()
    view.addSubview(topView)
    topView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topView.topAnchor.constraint(equalTo: view.topAnchor),
      topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      topView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
      topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    view.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
      imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
      imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
    ])

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    let xMarkButton = UIButton(type: .system)
    xMarkButton.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfig), for: [])
    xMarkButton.tintColor = .dark
    topView.addSubview(xMarkButton)
    xMarkButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      xMarkButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
      xMarkButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -24),
      xMarkButton.widthAnchor.constraint(equalToConstant: 36),
      xMarkButton.heightAnchor.constraint(equalToConstant: 36),
    ])
  }

  // MARK: Private

  private let bottomView: OnboardingBottomView = {
    let view = OnboardingBottomView()
    view.decorate(
      model: .init(
        titleText: "Найдем ближайший магазин",
        subtitleText: "Разрешите доступ к геолокации и мы покажем магазины,  где есть в наличие ваши любимые вина",
        buttonText: "Разрешить"))
    return view
  }()

  private let imageView: UIImageView = {
    $0.image = UIImage(named: "geoOnboarding")
    $0.contentMode = .scaleAspectFit
    return $0
  }(UIImageView())
}
