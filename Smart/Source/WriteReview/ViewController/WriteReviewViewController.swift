//
//  WriteReviewViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit
import Cosmos

final class WriteReviewViewController: UIViewController {
  
  // MARK: - Internal Properties
  
  var interactor: WriteReviewInteractorProtocol?
  
  // MARK: - Private Properties
  
  private(set) var loadingIndicator = ActivityIndicatorView()
  
  private lazy var ratingView: CosmosView = {
    var view = CosmosView()
    view.settings.filledColor = .accent
    view.settings.emptyBorderColor = .accent
    view.settings.starSize = 40
    view.settings.fillMode = .half
    view.settings.minTouchRating = 0
    return view
  }()
  
  private let ratingHintLabel: UILabel = {
    let label = UILabel()
    label.font = Font.regular(16)
    label.textColor = .blueGray
    label.text = "Tap a star to rate"
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
    textView.contentInset = .init(top: 0, left: 5, bottom: 5, right: 5)
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
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    edgesForExtendedLayout = []
    view.backgroundColor = .mainBackground
    
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.leftBarButtonItem = .init(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(closeSelf))
    
    navigationItem.rightBarButtonItem = .init(
      title: "Send",
      style: .plain,
      target: self,
      action: #selector(didTapSend))
        
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
      textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      bottomConstraint,
    ])
    
    configureKeyboardHelper()
    interactor?.viewDidLoad()
  }
    
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

// MARK: - WriteReviewViewControllerProtocol

extension WriteReviewViewController: WriteReviewViewControllerProtocol {
  
  func updateUI(viewModel: WriteReviewViewModel) {
    ratingView.rating = viewModel.rating ?? 0
    textView.text = viewModel.reviewText
    navigationItem.title = viewModel.navigationTitle
  }
  
  func setPlaceholder(placeholder: String?) {
    textView.placeholder = placeholder ?? ""
  }
}
