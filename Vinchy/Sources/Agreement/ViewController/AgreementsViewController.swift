//
//  AgreementsViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 22.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import DisplayMini
import StringFormatting
import UIKit

// MARK: - AgreementsViewControllerOutput

protocol AgreementsViewControllerOutput: AnyObject {
  func didConfirmAgeAndAgreement()
}

// MARK: - AgreementsViewController

final class AgreementsViewController: UIViewController, OpenURLProtocol, Alertable {

  // MARK: Internal

  weak var delegate: AgreementsViewControllerOutput?

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground
    navigationController?.setNavigationBarHidden(true, animated: false)

    let label = UILabel()
    label.font = Font.heavy(25)
    label.textColor = .blueGray
    label.numberOfLines = 0
    label.text = localized("before_we_start")

    let stackView = UIStackView(arrangedSubviews: [
      label,
      iamold,
      iamAgree,
    ])

    stackView.setCustomSpacing(10, after: iamold)
    stackView.axis = .vertical

    view.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
    ])
  }

  // MARK: Private

  private lazy var iamold: SwitcherWithText = {
    let view = SwitcherWithText()
    view.switcher.addTarget(self, action: #selector(didChangeValueOfSwitcher), for: .valueChanged)
    let attributedText = NSAttributedString(
      string: localized("legal_age"),
      font: Font.medium(18),
      textColor: .dark)
    view.decorate(model: .init(attributedText: attributedText))
    return view
  }()

  private lazy var iamAgree: SwitcherWithText = {
    let view = SwitcherWithText()
    view.switcher.addTarget(self, action: #selector(didChangeValueOfSwitcher), for: .valueChanged)

    let text = localized("terms_of_use_agreement")
    view.label.text = text
    view.label.textColor = .dark
    view.label.font = Font.medium(18)
    let underlineAttriString = NSMutableAttributedString(string: text)
    let range1 = (text as NSString).range(of: localized("terms_of_use"))
    underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
    underlineAttriString.addAttribute(NSAttributedString.Key.font, value: Font.medium(18), range: range1)
    underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.accent, range: range1)
    view.label.attributedText = underlineAttriString

    view.label.isUserInteractionEnabled = true
    view.label.lineBreakMode = .byWordWrapping
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_:)))
    tapGesture.numberOfTouchesRequired = 1
    view.label.addGestureRecognizer(tapGesture)

    return view
  }()

  @objc
  private func didChangeValueOfSwitcher() {
    if iamold.switcher.isOn && iamAgree.switcher.isOn {
      UserDefaultsConfig.isAdult = true
      UserDefaultsConfig.isAgreedToTermsAndConditions = true
      delegate?.didConfirmAgeAndAgreement()
    }
  }

  @objc
  private func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
    guard let text = iamAgree.label.text else { return }
    let emailRange = (text as NSString).range(of: localized("terms_of_use"))
    if gesture.didTapAttributedTextInLabel(label: iamAgree.label, inRange: emailRange) {
      openTerms()
    }
  }

  private func openTerms() {
    open(urlString: localized("terms_of_use_url"), errorCompletion: {
      showAlert(title: localized("error").firstLetterUppercased(), message: localized("open_url_error"))
    })
  }
}

// fileprivate extension UITapGestureRecognizer {
//
//  func didTapAttributedTextInLabel(
//    label: UILabel,
//    inRange targetRange: NSRange)
//  -> Bool
//  {
//
//    guard let attributedText = label.attributedText else {
//      return false
//    }
//
//    let mutableStr = NSMutableAttributedString(attributedString: attributedText)
//    mutableStr.addAttributes([NSAttributedString.Key.font: label.font ?? .boldSystemFont(ofSize: 18)],
//                             range: NSRange.init(location: 0, length: attributedText.length))
//
//    // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
//    let layoutManager = NSLayoutManager()
//    let textContainer = NSTextContainer(size: .zero)
//    let textStorage = NSTextStorage(attributedString: mutableStr)
//
//    // Configure layoutManager and textStorage
//    layoutManager.addTextContainer(textContainer)
//    textStorage.addLayoutManager(layoutManager)
//
//    // Configure textContainer
//    textContainer.lineFragmentPadding = 0.0
//    textContainer.lineBreakMode = label.lineBreakMode
//    textContainer.maximumNumberOfLines = label.numberOfLines
//    let labelSize = label.bounds.size
//    textContainer.size = labelSize
//
//    // Find the tapped character location and compare it to the specified range
//    let locationOfTouchInLabel = location(in: label)
//    let textBoundingBox = layoutManager.usedRect(for: textContainer)
//    let x = (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x
//    let y = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
//    let textContainerOffset = CGPoint(x: x, y: y)
//    let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
//                                                 y: locationOfTouchInLabel.y - textContainerOffset.y)
//    let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
//                                                        in: textContainer,
//                                                        fractionOfDistanceBetweenInsertionPoints: nil)
//    return NSLocationInRange(indexOfCharacter, targetRange)
//  }
// }
