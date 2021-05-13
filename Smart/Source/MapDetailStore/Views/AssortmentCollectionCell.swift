//
//  AssortmentCollectionCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 09.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

struct AssortmentCollectionCellViewModel: ViewModelProtocol {
  
  fileprivate let titleText: String?
  
  init(titleText: String?) {
    self.titleText = titleText
  }
}

final class AssortmentCollectionCell: UICollectionViewCell, Reusable {
  
  // MARK: - Private Properties
  
  private let button: Button = {
    $0.contentEdgeInsets = .init(top: 14, left: 14, bottom: 14, right: 14)
    return $0
  }(Button())
  
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

}

// MARK: - Decoratable

extension AssortmentCollectionCell: Decoratable {
  
  typealias ViewModel = AssortmentCollectionCellViewModel
  
  func decorate(model: ViewModel) {
    button.setTitle(model.titleText, for: .normal)
  }
}
