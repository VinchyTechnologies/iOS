//
//  WriteReviewViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import DisplayMini
import UIKit

// MARK: - WriteReviewViewController

final class WriteReviewViewController: UIViewController {

  // MARK: Lifecycle

  init() {
    super.init(nibName: nil, bundle: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Internal

  var interactor: WriteReviewInteractorProtocol?

  private(set) var loadingIndicator = ActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()

    edgesForExtendedLayout = []
    view.backgroundColor = .mainBackground

    navigationItem.largeTitleDisplayMode = .never
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark", withConfiguration: imageConfig),
      style: .plain,
      target: self,
      action: #selector(closeSelf))

    navigationItem.rightBarButtonItem = .init(customView: sendButton)

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

    navigationController?.presentationController?.delegate = self

    interactor?.viewDidLoad()
  }

  // MARK: Private

  private lazy var ratingView: StarsRatingView = {
    var view = StarsRatingView()
    view.settings.filledColor = .accent
    view.settings.emptyBorderColor = .accent
    view.settings.filledBorderColor = .accent
    view.settings.starSize = 40
    view.settings.fillMode = .half
    view.settings.minTouchRating = 0.5
    view.settings.emptyBorderWidth = 1.0
    view.didFinishTouchingCosmos = { [weak self] value in
      self?.interactor?.didChangeContent(comment: self?.textView.text, rating: value)
    }
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
    textView.customDelegate = self
    textView.keyboardDismissMode = .interactive
    textView.showsVerticalScrollIndicator = false
    textView.alwaysBounceVertical = true
    textView.placeholderColor = .blueGray
    textView.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    return textView
  }()

  private lazy var sendButton: Button = {
    $0.disable()
    $0.addTarget(self, action: #selector(didTapSendButton(_:)), for: .touchUpInside)
    return $0
  }(Button())

  private lazy var bottomConstraint = NSLayoutConstraint(
    item: textView,
    attribute: .bottom,
    relatedBy: .equal,
    toItem: view,
    attribute: .bottom,
    multiplier: 1,
    constant: -16)

  @objc
  private func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: UIApplication.shared.asKeyWindow)

    if notification.name == UIResponder.keyboardWillHideNotification {
      bottomConstraint.constant = .zero
    } else {
      bottomConstraint.constant = -keyboardViewEndFrame.height
    }
  }

  @objc
  private func closeSelf() {
    dismiss(animated: true)
  }

  @objc
  private func didTapSendButton(_ button: UIButton) {
    interactor?.didTapSend(rating: ratingView.rating, comment: textView.text)
  }
}

// MARK: UITextViewDelegate

extension WriteReviewViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    interactor?.didChangeContent(comment: textView.text, rating: ratingView.rating)
  }
}

// MARK: WriteReviewViewControllerProtocol

extension WriteReviewViewController: WriteReviewViewControllerProtocol {
  func updateUI(viewModel: WriteReviewViewModel) {
    ratingView.rating = viewModel.rating ?? 0
    textView.text = viewModel.reviewText
    navigationItem.title = viewModel.navigationTitle
    sendButton.setTitle(viewModel.rightBarButtonText, for: [])
    ratingHintLabel.text = viewModel.underStarText
  }

  func setPlaceholder(placeholder: String?) {
    textView.placeholder = placeholder ?? ""
  }

  func setSendButtonEnabled(_ flag: Bool) {
    flag ? sendButton.enable() : sendButton.disable()
  }
}

// MARK: UIAdaptivePresentationControllerDelegate

extension WriteReviewViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
    interactor?.didRequestToCloseController(comment: textView.text, rating: ratingView.rating) ?? true
  }
}
