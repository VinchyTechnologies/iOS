//
//  SMSCodeTextField.swift
//  VinchyAuthorization
//
//  Created by Михаил Исаченко on 01.07.2021.
//

import StringFormatting
import UIKit

// MARK: - OTPDelegate

protocol OTPDelegate: AnyObject {
  func didChangeText(_ text: String)
}

// MARK: - C

private enum C {
  static let defaultNumberOfFields = 4
  static let defaultSpacing = CGFloat(30)
  static let defaultFontSize = CGFloat(50)
}

// MARK: - OTPStackView

final class OTPStackView: UIStackView {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupStackView()
    addOTPFields()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public let numberOfFields: Int = C.defaultNumberOfFields

  public final func getOTP() -> String {
    var OTP = String()
    for textField in textFieldsCollection {
      guard let text = textField.text else {
        continue
      }
      OTP += text
    }
    return OTP
  }

  // MARK: Internal

  weak var delegate: OTPDelegate?

  // MARK: Private

  private var textFieldsCollection: [OTPTextField] = []
  private var remainingStringsStack: [Character] = []

  private final func setupStackView() {
    backgroundColor = .clear
    isUserInteractionEnabled = true
    translatesAutoresizingMaskIntoConstraints = false
    distribution = .fillEqually
    axis = .horizontal
    alignment = .center
    spacing = C.defaultSpacing
  }

  private final func addOTPFields() {
    for index in 0 ..< numberOfFields {
      let field = OTPTextField()
      setupTextField(field)
      textFieldsCollection.append(field)
      if index > 0 {
        field.previousTextField = textFieldsCollection[index - 1]
        textFieldsCollection[index - 1].nextTextField = field
      } else {
        field.previousTextField = nil
      }
      addArrangedSubview(field)
    }
    textFieldsCollection.first?.becomeFirstResponder()
  }

  private final func setupTextField(_ textField: OTPTextField) {
    textField.delegate = self
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textAlignment = .center
    textField.font = .systemFont(ofSize: C.defaultFontSize)
    textField.keyboardType = .numberPad
    textField.autocorrectionType = .yes
    textField.textContentType = .oneTimeCode
    textField.delegateOTP = self
  }

  private final func autoFillTextField(with string: String) {
    remainingStringsStack = string.reversed().compactMap { $0 }
    for textField in textFieldsCollection {
      if let charToAdd = remainingStringsStack.popLast() {
        textField.text = String(charToAdd)
      } else {
        break
      }
    }
    textFieldsCollection.last?.becomeFirstResponder()
    remainingStringsStack.removeAll()
  }
}

// MARK: UITextFieldDelegate

extension OTPStackView: UITextFieldDelegate {
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String)
    -> Bool
  {
    guard let textField = textField as? OTPTextField else {
      return false
    }
    if string.count > 1 && string.isNumeric {
      textField.resignFirstResponder()
      autoFillTextField(with: string)
      return false
    } else {
      if range.length == 0, string.isEmpty {
        return false
      } else if range.length == 0 {
        if !string.isNumeric {
          return false
        }
        guard let text = textField.text else {
          return false
        }
        if !text.isEmpty, textField.nextTextField != nil {
          textField.resignFirstResponder()
          textField.nextTextField?.becomeFirstResponder()
          textField.nextTextField?.text = string
        } else {
          textField.text = string
        }
        return false
      }
      return true
    }
  }
}

// MARK: OTPTextFieldDelegate

extension OTPStackView: OTPTextFieldDelegate {
  func didChangeText(_: OTPTextField, text _: String) {
    let fullText = getOTP()
    delegate?.didChangeText(fullText)
  }
}
