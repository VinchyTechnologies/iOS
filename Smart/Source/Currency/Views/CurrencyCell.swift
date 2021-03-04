//
//  CurrencyCell.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/25/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import StringFormatting
import Core

public struct CurrencyCellViewModel: ViewModelProtocol {
  
  public let title: String?
  public let isSelected: Bool?
  public let code: String?
  
  public init(title: String?, selected: Bool?, code: String?) {
    self.title = title
    self.isSelected = selected
    self.code = code
  }
}

final class CurrencyCell: UITableViewCell, Reusable {
  
  private enum Constants {
      static func iconBackgroundColor(isSelected: Bool) -> UIColor { isSelected ? .accent : .white }
      static func iconBorderColor(isSelected: Bool) -> UIColor? { isSelected ? nil : .lightGray }
      static func iconBorderWidth(isSelected: Bool) -> CGFloat { isSelected ? 0 : 1 }
  }
  
  private let checkBox: UIImageView = {
    let checkBox = UIImageView()
    checkBox.translatesAutoresizingMaskIntoConstraints = false
    checkBox.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
    checkBox.tintColor = .white
    checkBox.contentMode = .scaleAspectFit
    checkBox.layer.cornerRadius = 4
    checkBox.layer.borderWidth = 1
    checkBox.layer.borderColor = UIColor.lightGray.cgColor
    
    return checkBox
  }()
  
  private let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.bold(16)
    label.textColor = .dark
    
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      label.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    
    contentView.addSubview(checkBox)
    checkBox.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      checkBox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      checkBox.centerYAnchor.constraint(equalTo: centerYAnchor),
      checkBox.widthAnchor.constraint(equalToConstant: 25),
      checkBox.heightAnchor.constraint(equalToConstant: 25),
    ])
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}

extension CurrencyCell: Decoratable {
  
  typealias ViewModel = CurrencyCellViewModel
  
  func decorate(model: ViewModel) {
    label.text = model.title

    let isSelected = model.isSelected
    checkBox.backgroundColor = Constants.iconBackgroundColor(isSelected: isSelected ?? false)
    checkBox.layer.borderColor = Constants.iconBorderColor(isSelected: isSelected ?? false)?.cgColor
    checkBox.layer.borderWidth = Constants.iconBorderWidth(isSelected: isSelected ?? false)

  }
}
