//
//  CommonEditCollectionViewCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import UIKit

// MARK: - CommonEditCollectionViewCellDelegate

protocol CommonEditCollectionViewCellDelegate: AnyObject {
  func didChangedText(_ textField: UITextField, recognizableIdentificator: String?)
}

// MARK: - CommonEditCollectionViewCellViewModel

struct CommonEditCollectionViewCellViewModel: ViewModelProtocol {
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

// MARK: - CommonEditCollectionViewCell

final class CommonEditCollectionViewCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(textField)
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: contentView.topAnchor),
      textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  weak var delegate: CommonEditCollectionViewCellDelegate?

  static func height(for _: ViewModel?) -> CGFloat {
    44
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

// MARK: Decoratable

extension CommonEditCollectionViewCell: Decoratable {
  typealias ViewModel = CommonEditCollectionViewCellViewModel

  func decorate(model: ViewModel) {
    recognizableIdentificator = model.recognizableIdentificator
    textField.text = model.text
    if let placeholder = model.placeholder {
      textField.attributedPlaceholder = NSAttributedString(
        string: placeholder,
        font: Font.heavy(18),
        textColor: .blueGray)
    }
    textField.isUserInteractionEnabled = model.isEditable
  }
}
