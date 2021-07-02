//
//  NewAgreementsBottomView.swift
//  Smart
//
//  Created by Алексей Смирнов on 26.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Display
import StringFormatting
import UIKit

// MARK: - NewAgreementsBottomViewDelegate

protocol NewAgreementsBottomViewDelegate: AnyObject {
  func didTapContinurButton(_ button: UIButton)
  func didTapOpenTerms()
}

// MARK: - NewAgreementsBottomViewModel

struct NewAgreementsBottomViewModel: ViewModelProtocol {

  fileprivate let titleText: String?
  fileprivate let subtitleText: String?
  fileprivate let buttonText: String?

  init(titleText: String?, subtitleText: String?, buttonText: String?) {
    self.titleText = titleText
    self.subtitleText = subtitleText
    self.buttonText = buttonText
  }
}

// MARK: - NewAgreementsBottomView

final class NewAgreementsBottomView: UIView {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    clipsToBounds = true

    layer.cornerRadius = 30
    layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

    backgroundColor = .option

    let stackView = UIStackView()
    yellowButton.addTarget(self, action: #selector(didTapContinurButton(_:)), for: .touchUpInside)
    yellowButton.translatesAutoresizingMaskIntoConstraints = false
    yellowButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8).isActive = true
    yellowButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

    yellowButton.setTitle(localized("continue").firstLetterUppercased(), for: [])

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
    titleLabel.text = localized("before_we_start")

    subtitleLabel.minimumScaleFactor = 0.2
    subtitleLabel.adjustsFontSizeToFitWidth = true
    subtitleLabel.numberOfLines = 0
    subtitleLabel.font = .systemFont(ofSize: 18)
    subtitleLabel.textColor = .blueGray
    subtitleLabel.textAlignment = .center
    subtitleLabel.baselineAdjustment = .alignCenters

    let text = localized("terms_of_use_agreement")
    subtitleLabel.text = text
    let underlineAttriString = NSMutableAttributedString(string: text)
    let range1 = (text as NSString).range(of: localized("terms_of_use"))
    underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
    underlineAttriString.addAttribute(NSAttributedString.Key.font, value: Font.medium(18), range: range1)
    underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.accent, range: range1)
    subtitleLabel.attributedText = underlineAttriString

    subtitleLabel.isUserInteractionEnabled = true
    subtitleLabel.lineBreakMode = .byWordWrapping
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_:)))
    tapGesture.numberOfTouchesRequired = 1
    subtitleLabel.addGestureRecognizer(tapGesture)

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

  weak var delegate: NewAgreementsBottomViewDelegate?

  // MARK: Private

  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let yellowButton = Button()

  @objc
  private func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
    guard let text = subtitleLabel.text else { return }
    let emailRange = (text as NSString).range(of: localized("terms_of_use"))
    if gesture.didTapAttributedTextInLabel(label: subtitleLabel, inRange: emailRange) {
      openTerms()
    }
  }

  private func openTerms() {
    delegate?.didTapOpenTerms()
  }

  @objc
  private func didTapContinurButton(_ button: UIButton) {
    delegate?.didTapContinurButton(button)
  }

}

// MARK: Decoratable

//extension NewAgreementsBottomView: Decoratable {
//  typealias ViewModel = NewAgreementsBottomViewModel
//
//  func decorate(model: ViewModel) {
////    titleLabel.text = model.titleText
//    subtitleLabel.text = model.subtitleText
//    yellowButton.setTitle(model.buttonText, for: [])
//  }
//}
