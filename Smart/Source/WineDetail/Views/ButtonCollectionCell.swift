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
  func didTapDislikeButton(_ button: UIButton)
  func didTapReportAnErrorButton(_ button: UIButton)
}

struct ButtonCollectionCellViewModel: ViewModelProtocol {
  
  enum Button {
    case dislike(title: NSAttributedString?, image: UIImage?, selectedImage: UIImage?, isDisliked: Bool)
    case reportError(title: NSAttributedString?)
  }
  
  fileprivate let buttonModel: Button
  
  public init(buttonModel: Button) {
    self.buttonModel = buttonModel
  }
}

final class ButtonCollectionCell: UICollectionViewCell, Reusable {
  
  // MARK: - Internal Properties
  
  weak var delegate: ButtonCollectionCellDelegate?
  
  // MARK: - Private Properties
  
  private var type: ButtonCollectionCellViewModel.Button?
  private let button = UIButton()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.dark.cgColor
    button.tintColor = .dark
    button.imageEdgeInsets = .init(top: 0, left: -10, bottom: 0, right: 10)
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
    
    guard let type = type else { return }
    
    switch type {
    case .dislike:
      delegate?.didTapDislikeButton(button)
      
    case .reportError:
      delegate?.didTapReportAnErrorButton(button)
    }
  }
}

// MARK: - Decoratable

extension ButtonCollectionCell: Decoratable {
  
  typealias ViewModel = ButtonCollectionCellViewModel
  
  func decorate(model: ViewModel) {
    
    type = model.buttonModel
    
    switch model.buttonModel {
    case .dislike(let title, let image, let selectedImage, let isDisliked):
      button.isSelected = isDisliked
      
      button.setAttributedTitle(title, for: .normal)
      
      if let selectedImage = selectedImage {
        button.setImage(selectedImage, for: .selected)
      } else {
        button.setImage(nil, for: .selected)
      }
      
      if let normalImage = image {
        button.setImage(normalImage, for: .normal)
      } else {
        button.setImage(nil, for: .normal)
      }
      
    case .reportError(let title):
      button.setAttributedTitle(title, for: .normal)
    }
  }
}
