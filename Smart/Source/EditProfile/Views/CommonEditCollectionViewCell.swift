//
//  CommonEditCollectionViewCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - CommonEditCollectionViewCellViewModel

struct CommonEditCollectionViewCellViewModel: ViewModelProtocol {
  let recognizableIdentificator: String?
  fileprivate let text: String?
  fileprivate let placeholder: String?

  init(recognizableIdentificator: String?, text: String?, placeholder: String?) {
    self.recognizableIdentificator = recognizableIdentificator
    self.text = text
    self.placeholder = placeholder
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

  static func height(for _: ViewModel?) -> CGFloat {
    44
  }

  // MARK: Private

  private let textField: UITextField = {
    $0.font = Font.heavy(18)
    $0.textColor = .dark
    $0.tintColor = .accent
    return $0
  }(UITextField())
}

// MARK: Decoratable

extension CommonEditCollectionViewCell: Decoratable {
  typealias ViewModel = CommonEditCollectionViewCellViewModel

  func decorate(model: ViewModel) {
    textField.text = model.text
    if let placeholder = model.placeholder {
      textField.attributedPlaceholder = NSAttributedString(
        string: placeholder,
        font: Font.heavy(18),
        textColor: .blueGray)
    }
  }
}
