//
//  WriteNoteViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 28.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import Database
import VinchyCore
import StringFormatting

final class WriteNoteViewController: UIViewController {

  // MARK: - Interanal Properties

  var interactor: WriteNoteInteractorProtocol?

  // MARK: - Private Properties

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
    view.backgroundColor = .mainBackground

    navigationItem.largeTitleDisplayMode = .never
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .save,
      target: self,
      action: #selector(didTapSave(_:)))

    view.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: view.topAnchor),
      textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomConstraint,
    ])
    
    configureKeyboardHelper()
    interactor?.viewDidLoad()
    interactor?.didStartWriteText()
  }
  
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
  private func didTapSave(_ barButtonItem: UIBarButtonItem) {
    interactor?.didTapSave()
  }
}

// MARK: - UITextViewDelegate

extension WriteNoteViewController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    interactor?.didChangeNoteText(textView.text)
  }
}

// MARK: - WriteNoteViewControllerProtocol

extension WriteNoteViewController: WriteNoteViewControllerProtocol {
  
  func setupPlaceholder(placeholder: String?) {
    textView.placeholder = placeholder ?? ""
  }
  
  func update(viewModel: WriteNoteViewModel) {
    if let noteText = viewModel.noteText, !noteText.isEmpty {
      textView.text = noteText
    } else {
      textView.becomeFirstResponder()
    }
    navigationItem.title = viewModel.navigationText
  }
}
