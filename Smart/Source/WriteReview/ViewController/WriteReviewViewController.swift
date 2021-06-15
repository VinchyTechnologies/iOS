//
//  WriteReviewViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Cosmos
import Display
import UIKit

// MARK: - WriteReviewViewController

final class WriteReviewViewController: UIViewController {

  // MARK: Internal

  var interactor: WriteReviewInteractorProtocol?

  private(set) var loadingIndicator = ActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()

    edgesForExtendedLayout = []
    view.backgroundColor = .mainBackground

    navigationItem.largeTitleDisplayMode = .never
    navigationItem.leftBarButtonItem = .init(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(closeSelf))

    view.addSubview(ratingView)
    ratingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
      ratingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])

    view.addSubview(ratingHintLabel)
    ratingHintLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingHintLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 6),
      ratingHintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])

    let line = UIView()
    line.backgroundColor = .separator
    view.addSubview(line)
    line.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      line.topAnchor.constraint(equalTo: ratingHintLabel.bottomAnchor, constant: 4),
      line.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      line.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      line.heightAnchor.constraint(equalToConstant: 0.5),
    ])

    view.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: line.bottomAnchor),
      textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomConstraint,
    ])

    configureKeyboardHelper()
    interactor?.viewDidLoad()
  }

  // MARK: Private

  private lazy var ratingView: CosmosView = {
    var view = CosmosView()
    view.settings.filledColor = .accent
    view.settings.emptyBorderColor = .accent
    view.settings.starSize = 40
    view.settings.fillMode = .half
    view.settings.minTouchRating = 0.5
    return view
  }()

  private let ratingHintLabel: UILabel = {
    let label = UILabel()
    label.font = Font.regular(16)
    label.textColor = .blueGray
    return label
  }()

  private lazy var textView: PlaceholderTextView = {
    let textView = PlaceholderTextView()
    textView.font = Font.dinAlternateBold(18)
//    textView.customDelegate = self
    textView.keyboardDismissMode = .interactive
    textView.showsVerticalScrollIndicator = false
    textView.alwaysBounceVertical = true
    textView.placeholderColor = .blueGray
    textView.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    return textView
  }()

  private let keyboardHelper = KeyboardHelper()

  private lazy var bottomConstraint = NSLayoutConstraint(
    item: textView,
    attribute: .bottom,
    relatedBy: .equal,
    toItem: view,
    attribute: .bottom,
    multiplier: 1,
    constant: -16)

  // MARK: - Private Methods

  private func configureKeyboardHelper() {
    keyboardHelper.bindBottomToKeyboardFrame(
      animated: true,
      animate: { [weak self] height in
        self?.updateNextButtonBottomConstraint(with: height)
      })
  }

  private func updateNextButtonBottomConstraint(with keyboardHeight: CGFloat) {
    bottomConstraint.constant = -keyboardHeight
    view.layoutSubviews()
  }

  @objc
  private func closeSelf() {
    dismiss(animated: true)
  }

  @objc
  private func didTapSend() {
    interactor?.didTapSend(rating: ratingView.rating, comment: textView.text)
  }
}

// MARK: WriteReviewViewControllerProtocol

extension WriteReviewViewController: WriteReviewViewControllerProtocol {
  func updateUI(viewModel: WriteReviewViewModel) {
    ratingView.rating = viewModel.rating ?? 0
    textView.text = viewModel.reviewText
    navigationItem.title = viewModel.navigationTitle
    navigationItem.rightBarButtonItem = .init(
      title: viewModel.rightBarButtonText,
      style: .plain,
      target: self,
      action: #selector(didTapSend))
    ratingHintLabel.text = viewModel.underStarText
  }

  func setPlaceholder(placeholder: String?) {
    textView.placeholder = placeholder ?? ""
  }
}
