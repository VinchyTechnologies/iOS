//
//  OnboardingFeatureView.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - OnboardingFeatureViewViewModel

struct OnboardingFeatureViewViewModel: ViewModelProtocol {

  enum Style {
    case bottles, geo, rating
  }

  fileprivate let style: Style

  init(style: Style) {
    self.style = style
  }
}

// MARK: - OnboardingFeatureView

final class OnboardingFeatureView: UIView {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    let vStackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
    vStackView.axis = .vertical
    vStackView.spacing = 12

    addSubview(vStackView)
    vStackView.translatesAutoresizingMaskIntoConstraints = false
    vStackView.fill()
    vStackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Private

  private let imageView: UIImageView = {
    $0.contentMode = .scaleAspectFit
    return $0
  }(UIImageView())

  private let titleLabel: UILabel = {
    $0.setContentCompressionResistancePriority(.required, for: .vertical)
    $0.font = Font.regular(18)
    $0.numberOfLines = 0
    $0.textAlignment = .center
    $0.text = "Подобрать вино по любому случаю"
    return $0
  }(UILabel())
}

// MARK: Decoratable

extension OnboardingFeatureView: Decoratable {
  typealias ViewModel = OnboardingFeatureViewViewModel

  func decorate(model: ViewModel) {
    switch model.style {
    case .bottles:
      imageView.image = UIImage(named: "onboadingThreeBottles")
      titleLabel.text = "Умные рекомендации вина"

    case .geo:
      imageView.image = UIImage(named: "onboardingFeatureGeo")
      titleLabel.text = "Цены и ассортимент магазинов"

    case .rating:
      imageView.image = UIImage(named: "onboardingFeatureRating")
      titleLabel.text = "Реальные отзывы и рейтинги"
    }
  }
}
