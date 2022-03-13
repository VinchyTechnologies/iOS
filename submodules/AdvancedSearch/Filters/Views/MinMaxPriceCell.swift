//
//  MinMaxPriceCell.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import DisplayMini
import EpoxyCore
import EpoxyLayoutGroups
import StringFormatting
import UIKit

// MARK: - MinMaxPriceView

final class MinMaxPriceView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(hStack)
    hStack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hStack.topAnchor.constraint(equalTo: topAnchor),
      hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
      hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
      hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Behaviors {
    public let didEndEditing: (_ minPrice: Int?, _ maxPrice: Int?) -> Void
    public init(didEndEditing: @escaping ((_ minPrice: Int?, _ maxPrice: Int?) -> Void)) {
      self.didEndEditing = didEndEditing
    }
  }

  // MARK: Internal

  struct Content: Equatable {
    let minPrice: String?
    let maxPrice: String?
    let minPlaceHolderText: String
    let maxPlaceHolderText: String
    let decimalDigits: Int
    let currencyCode: String

    init(minPrice: String?, maxPrice: String?, minPlaceHolderText: String, maxPlaceHolderText: String, decimalDigits: Int, currencyCode: String) {
      self.minPrice = minPrice
      self.maxPrice = maxPrice
      self.minPlaceHolderText = minPlaceHolderText
      self.maxPlaceHolderText = maxPlaceHolderText
      self.decimalDigits = decimalDigits
      self.currencyCode = currencyCode
    }
  }
  struct Style: Hashable {

  }

  var content: Content?

  func setBehaviors(_ behaviors: Behaviors?) {
    didEndEditing = behaviors?.didEndEditing
  }

  func setContent(_ content: Content, animated: Bool) {
    self.content = content
    minTextField.placeholder = content.minPlaceHolderText
    maxTextField.placeholder = content.maxPlaceHolderText
    if let minPrice = content.minPrice, let minIntValue = Int64(minPrice) {
      minTextField.text = formatCurrencyAmount(minIntValue, currency: content.currencyCode, shouldAddSymbol: false)
      textFieldDidChange(minTextField)
    }
    if let maxPrice = content.maxPrice, let maxIntValue = Int64(maxPrice) {
      maxTextField.text = formatCurrencyAmount(maxIntValue, currency: content.currencyCode, shouldAddSymbol: false)
      textFieldDidChange(maxTextField)
    }
  }

  // MARK: Private

  private var didEndEditing: ((_ minPrice: Int?, _ maxPrice: Int?) -> Void)?

  private lazy var minTextField: TextField = {
    $0.backgroundColor = .option
    $0.layer.cornerRadius = 15
    $0.clipsToBounds = true
    $0.tintColor = .accent
    $0.keyboardType = .decimalPad
    $0.font = Font.with(size: 20, design: .round, traits: .bold) //Font.medium(20)
    $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    $0.delegate = self
    $0.adjustsFontSizeToFitWidth = true
    return $0
  }(TextField())

  private lazy var maxTextField: TextField = {
    $0.backgroundColor = .option
    $0.layer.cornerRadius = 15
    $0.clipsToBounds = true
    $0.tintColor = .accent
    $0.keyboardType = .decimalPad
    $0.font = Font.with(size: 20, design: .round, traits: .bold) //Font.medium(20)
    $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    $0.delegate = self
    $0.adjustsFontSizeToFitWidth = true
    return $0
  }(TextField())

  private lazy var hStack: UIStackView = {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.spacing = 16
    return $0
  }(UIStackView(arrangedSubviews: [minTextField, maxTextField]))

  private var minValue: Double? {
    if let minText = minTextField.text, !minText.isNilOrEmpty, let content = content {
      let minText = minText.dropFirst((content.minPlaceHolderText + " ").count)
      return Double(minText)
    }
    return nil
  }

  private var maxValue: Double? {
    if let maxText = maxTextField.text, !maxText.isNilOrEmpty, let content = content {
      let maxText = maxText.dropFirst((content.maxPlaceHolderText + " ").count)
      return Double(maxText)
    }
    return nil
  }

  @objc
  private func textFieldDidChange(_ textField: UITextField) {

    guard let content = content else {
      return
    }

    if textField === minTextField {
      if textField.text?.replacingOccurrences(of: " ", with: "") == content.minPlaceHolderText {
        textField.text = nil
        return
      }

      let minPlaceHolderTextWithSpace = content.minPlaceHolderText + " "
      if (textField.text?.prefix(minPlaceHolderTextWithSpace.count) ?? "") != minPlaceHolderTextWithSpace {
        textField.text = minPlaceHolderTextWithSpace + (textField.text ?? "")
      }
    }

    if textField === maxTextField {
      if textField.text?.replacingOccurrences(of: " ", with: "") == content.maxPlaceHolderText {
        textField.text = nil
        return
      }

      let maxPlaceHolderTextWithSpace = content.maxPlaceHolderText + " "
      if (textField.text?.prefix(maxPlaceHolderTextWithSpace.count) ?? "") != maxPlaceHolderTextWithSpace {
        textField.text = maxPlaceHolderTextWithSpace + (textField.text ?? "")
      }
    }
  }
}

// MARK: UITextFieldDelegate

extension MinMaxPriceView: UITextFieldDelegate {

  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String)
    -> Bool
  {
    guard let content = content else {
      return true
    }
    if textField.text.isNilOrEmpty {
      return true
    }

    if textField === minTextField {
      if range.location < (content.minPlaceHolderText + " ").count {
        return false
      }
      return true
    }

    if textField === maxTextField {
      if range.location < (content.maxPlaceHolderText + " ").count {
        return false
      }
      return true
    }

    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let content = content else {
      return
    }

    if textField === minTextField {
      if let minValue = minValue, let maxValue = maxValue, minValue > maxValue {
        minTextField.text = nil
      }
    }

    if textField === maxTextField {
      if let minValue = minValue, let maxValue = maxValue, maxValue < minValue {
        maxTextField.text = nil
      }
    }

    var minVal: Int?
    var maxVal: Int?

    if let minValue = minValue {
      minVal = Int(minValue * pow(10, Double(content.decimalDigits)))
    }

    if let maxValue = maxValue {
      maxVal = Int(maxValue * pow(10, Double(content.decimalDigits)))
    }

    didEndEditing?(minVal, maxVal)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    endEditing(true)
    return true
  }
}

// MARK: - TextField

fileprivate final class TextField: UITextField {

  let inset: CGFloat = 10

  // placeholder position
  override func textRect(forBounds: CGRect) -> CGRect {
    forBounds.insetBy(dx: inset , dy: inset)
  }

  // text position
  override func editingRect(forBounds: CGRect) -> CGRect {
    forBounds.insetBy(dx: inset , dy: inset)
  }

  override func placeholderRect(forBounds: CGRect) -> CGRect {
    forBounds.insetBy(dx: inset, dy: inset)
  }
}
