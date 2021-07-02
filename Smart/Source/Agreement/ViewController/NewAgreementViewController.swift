//
//  NewAgreementViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 26.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Display
import StringFormatting
import UIKit

// MARK: - NewAgreementViewController

final class NewAgreementViewController: UIViewController, OpenURLProtocol, Alertable {

  // MARK: Internal

  weak var delegate: AgreementsViewControllerOutput?

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
      topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      topView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    view.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
      imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
      imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
    ])

    view.bringSubviewToFront(bottomView)
  }

  // MARK: Private

  private lazy var bottomView: NewAgreementsBottomView = {
    let view = NewAgreementsBottomView()
    view.delegate = self
    return view
  }()

  private let imageView: UIImageView = {
    $0.image = UIImage(named: "bottleBackground")
    $0.contentMode = .scaleAspectFit
    return $0
  }(UIImageView())
}

// MARK: NewAgreementsBottomViewDelegate

extension NewAgreementViewController: NewAgreementsBottomViewDelegate {

  func didTapOpenTerms() {
    open(urlString: localized("terms_of_use_url"), errorCompletion: {
      showAlert(title: localized("error").firstLetterUppercased(), message: localized("open_url_error"))
    })
  }

  func didTapContinurButton(_ button: UIButton) {
    UserDefaultsConfig.isAdult = true
    UserDefaultsConfig.isAgreedToTermsAndConditions = true
    delegate?.didConfirmAgeAndAgreement()
  }
}
