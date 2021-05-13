//
//  WorkingHoursCollectionCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 08.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

struct WorkingHoursCollectionCellViewModel: ViewModelProtocol {
  
  fileprivate let titleText: String?
  
  init(titleText: String?) {
    self.titleText = titleText
  }
}

final class WorkingHoursCollectionCell: UICollectionViewCell, Reusable {
  
  // MARK: - Private Properties
  
  private let button: UIButton = {
    $0.contentEdgeInsets = .init(top: 14, left: 14, bottom: 14, right: 14)
    $0.imageEdgeInsets = .init(top: 0, left: -4, bottom: 0, right: 4)
    $0.backgroundColor = .option
    $0.setTitleColor(.dark, for: .normal)
    $0.setImage(
      UIImage(systemName: "clock")?.withTintColor(.blueGray, renderingMode: .alwaysOriginal), for: .normal)
    $0.titleLabel?.font = Font.regular(16)
    return $0
  }(UIButton())
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
        
    addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: topAnchor),
      button.bottomAnchor.constraint(equalTo: bottomAnchor),
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  // MARK: - Public Methods
  
  override func layoutSubviews() {
    super.layoutSubviews()
    button.layer.cornerRadius = button.frame.height / 2
  }
}

// MARK: - Decoratable

extension WorkingHoursCollectionCell: Decoratable {
  
  typealias ViewModel = WorkingHoursCollectionCellViewModel
  
  func decorate(model: ViewModel) {
    button.setTitle(model.titleText, for: .normal)
  }
}
