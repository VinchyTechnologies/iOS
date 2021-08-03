//
//  GeoOnboardingViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 25.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - GeoOnboardingViewController

final class GeoOnboardingViewController: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .mainBackground

    addSubview(bottomView)
    bottomView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
      bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
      bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
      bottomView.heightAnchor.constraint(equalToConstant: 325),
    ])

    let topView = UIView()
    addSubview(topView)
    topView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topView.topAnchor.constraint(equalTo: topAnchor),
      topView.leadingAnchor.constraint(equalTo: leadingAnchor),
      topView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
      topView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])

    addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
      imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.92),
      imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.92),
    ])

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    let xMarkButton = UIButton(type: .system)
    xMarkButton.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfig), for: [])
    xMarkButton.tintColor = .dark
    xMarkButton.addTarget(self, action: #selector(didTapCloseSelf), for: .touchUpInside)

    topView.addSubview(xMarkButton)
    xMarkButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      xMarkButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
      xMarkButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -24),
      xMarkButton.widthAnchor.constraint(equalToConstant: 36),
      xMarkButton.heightAnchor.constraint(equalToConstant: 36),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  weak var delegate: OnboardingPageDelegate?

  // MARK: Private

  private lazy var bottomView: OnboardingBottomView = {
    let view = OnboardingBottomView()
    view.decorate(
      model: .init(
        titleText: "Найдем ближайший магазин",
        subtitleText: "Разрешите доступ к геолокации и мы покажем магазины,  где есть в наличие ваши любимые вина",
        buttonText: "Разрешить"))
    view.delegate = self
    return view
  }()

  private let imageView: UIImageView = {
    $0.image = UIImage(named: "geoOnboarding")
    $0.contentMode = .scaleAspectFit
    return $0
  }(UIImageView())

  @objc
  private func didTapCloseSelf() {
    delegate?.didTapCloseButton()
  }
}

// MARK: OnboardingBottomViewDelegate

extension GeoOnboardingViewController: OnboardingBottomViewDelegate {
  func didTapYellowButton(_ button: UIButton) {
    delegate?.didTapNexButton()
  }
}
