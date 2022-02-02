//
//  MinMaxPriceCell.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import DisplayMini
import UIKit

// MARK: - MinMaxPriceCellViewModel

struct MinMaxPriceCellViewModel: ViewModelProtocol {

}

// MARK: - MinMaxPriceCell

final class MinMaxPriceCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(hStack)
    hStack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hStack.topAnchor.constraint(equalTo: topAnchor),
      hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
      hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Private

  private let minTextField: TextField = {
    $0.backgroundColor = .option
    $0.layer.cornerRadius = 15
    $0.clipsToBounds = true
    $0.placeholder = "От"
    $0.tintColor = .accent
    $0.keyboardType = .numberPad
    $0.font = Font.medium(20)
    return $0
  }(TextField())

  private let maxTextField: TextField = {
    $0.backgroundColor = .option
    $0.layer.cornerRadius = 15
    $0.clipsToBounds = true
    $0.placeholder = "До"
    $0.tintColor = .accent
    $0.keyboardType = .numberPad
    $0.font = Font.medium(20)
    return $0
  }(TextField())

  private lazy var hStack: UIStackView = {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.spacing = 16
    return $0
  }(UIStackView(arrangedSubviews: [minTextField, maxTextField]))
}

// MARK: Decoratable

extension MinMaxPriceCell: Decoratable {

  typealias ViewModel = MinMaxPriceCellViewModel

  func decorate(model: ViewModel) {

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
