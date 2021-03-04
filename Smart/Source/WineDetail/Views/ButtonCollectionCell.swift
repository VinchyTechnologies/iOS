//
//  ButtonCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 26.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

protocol ButtonCollectionCellDelegate: AnyObject {
  func didTapReviewButton(_ button: UIButton)
}

struct ButtonCollectionCellViewModel: ViewModelProtocol {
  
  fileprivate let buttonText: String?
  
  public init(buttonText: String?) {
    self.buttonText = buttonText
  }
}

final class ButtonCollectionCell: UICollectionViewCell, Reusable {
  
  // MARK: - Internal Properties
  
  weak var delegate: ButtonCollectionCellDelegate?
  
  // MARK: - Private Properties
  
  private let button = Button()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    button.enable()    
    button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    addSubview(button)
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    button.frame = bounds
    button.layer.cornerRadius = bounds.height / 2
    button.clipsToBounds = true
  }
  
  // MARK: - Private Methhods
  
  @objc
  private func didTap(_ button: UIButton) {
    delegate?.didTapReviewButton(button)
  }
}

// MARK: - Decoratable

extension ButtonCollectionCell: Decoratable {
  
  typealias ViewModel = ButtonCollectionCellViewModel
  
  func decorate(model: ViewModel) {
    button.setTitle(model.buttonText, for: .normal)
  }
}
