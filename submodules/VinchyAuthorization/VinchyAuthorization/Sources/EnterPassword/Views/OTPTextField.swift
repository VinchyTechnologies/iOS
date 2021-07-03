//
//  OTPField.swift
//  VinchyAuthorization
//
//  Created by Михаил Исаченко on 01.07.2021.
//

import UIKit

// MARK: - OTPTextFieldDelegate

protocol OTPTextFieldDelegate: AnyObject {
  func didChangeText(_ otpTextField: OTPTextField, text: String)
}

// MARK: - OTPTextField

class OTPTextField: UITextField {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    addBottomLine()
    addEmptyView()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public var bottomLineWidth: CGFloat = 4
  public weak var previousTextField: OTPTextField?
  public weak var nextTextField: OTPTextField?

  public func setBottomLineColor(_ color: UIColor) {
    bottomLine.backgroundColor = color
  }

  override public func deleteBackward() {
    text?.removeAll()
    previousTextField?.becomeFirstResponder()
  }

  // MARK: Internal

  weak var delegateOTP: OTPTextFieldDelegate?

  override var text: String? {
    didSet {
      guard let text = text else {
        return
      }
      delegateOTP?.didChangeText(self, text: text)
      if !text.isEmpty {
        bottomLine.backgroundColor = .accent
      } else {
        bottomLine.backgroundColor = .blueGray
      }
    }
  }

  override func caretRect(for _: UITextPosition) -> CGRect {
    .zero
  }

  // MARK: Private

  private lazy var bottomLine: UIView = {
    let bottomLine = UIView()
    bottomLine.translatesAutoresizingMaskIntoConstraints = false
    bottomLine.backgroundColor = .blueGray
    bottomLine.layer.cornerRadius = 2
    return bottomLine
  }()

  private func addBottomLine() {
    addSubview(bottomLine)

    NSLayoutConstraint.activate([
      bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
      bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
      bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
      bottomLine.heightAnchor.constraint(equalToConstant: bottomLineWidth),
    ])
  }

  private func addEmptyView() {
    let view = UIView()
    addSubview(view)
    view.backgroundColor = .clear
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: topAnchor),
      view.leadingAnchor.constraint(equalTo: leadingAnchor),
      view.bottomAnchor.constraint(equalTo: bottomAnchor),
      view.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }

}
