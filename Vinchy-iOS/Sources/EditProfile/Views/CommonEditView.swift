//
//  CommonEditCollectionViewCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import EpoxyCore
import UIKit

// MARK: - CommonEditCollectionViewCellDelegate

protocol CommonEditCollectionViewCellDelegate: AnyObject {
  func didChangedText(_ textField: UITextField, recognizableIdentificator: String?)
}

// MARK: - CommonEditCollectionViewCellViewModel

struct CommonEditCollectionViewCellViewModel: Equatable {
  let recognizableIdentificator: String?
  fileprivate let text: String?
  fileprivate let placeholder: String?
  fileprivate let isEditable: Bool

  init(recognizableIdentificator: String?, text: String?, placeholder: String?, isEditable: Bool) {
    self.recognizableIdentificator = recognizableIdentificator
    self.text = text
    self.placeholder = placeholder
    self.isEditable = isEditable
  }
}

// MARK: - CommonEditView

final class CommonEditView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .zero
    addSubview(textField)
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: topAnchor),
      textField.leadingAnchor.constraint(equalTo: leadingAnchor),
      textField.bottomAnchor.constraint(equalTo: bottomAnchor),
      textField.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

  }

  typealias Content = CommonEditCollectionViewCellViewModel

  weak var delegate: CommonEditCollectionViewCellDelegate?

  static func height(for _: Content?) -> CGFloat {
    44
  }

  func setContent(_ content: Content, animated: Bool) {
    recognizableIdentificator = content.recognizableIdentificator
    textField.text = content.text
    if let placeholder = content.placeholder {
      textField.attributedPlaceholder = NSAttributedString(
        string: placeholder,
        font: Font.heavy(18),
        textColor: .blueGray)
    }
    textField.isUserInteractionEnabled = content.isEditable
  }

  // MARK: Private

  private var recognizableIdentificator: String?
  private lazy var textField: UITextField = {
    $0.font = Font.heavy(18)
    $0.textColor = .dark
    $0.tintColor = .accent
    $0.addTarget(self, action: #selector(didChangedText(_:)), for: .editingChanged)
    return $0
  }(UITextField())

  @objc
  private func didChangedText(_ textField: UITextField) {
    delegate?.didChangedText(
      textField,
      recognizableIdentificator: recognizableIdentificator)
  }
}
