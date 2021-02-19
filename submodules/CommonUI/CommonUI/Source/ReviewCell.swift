//
//  ReviewCell.swift
//  CommonUI
//
//  Created by Алексей Смирнов on 19.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct ReviewCellViewModel: ViewModelProtocol {
  
  fileprivate let userNameText: String?
  fileprivate let dateText: String?
  fileprivate let reviewText: String?
  fileprivate let rate: Double?
  
  public init(
    userNameText: String?,
    dateText: String?,
    reviewText: String?,
    rate: Double?)
  {
    self.userNameText = userNameText
    self.dateText = dateText
    self.reviewText = reviewText
    self.rate = rate
  }
}

public final class ReviewCell: UICollectionViewCell, Reusable {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .option
    layer.cornerRadius = 20
    clipsToBounds = true
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
}

extension ReviewCell: Decoratable {
  
  public typealias ViewModel = ReviewCellViewModel
  
  public func decorate(model: ViewModel) {
  }
}
