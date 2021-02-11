//
//  StarRatingControlCollectionCell .swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/8/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import Cosmos

struct StarRatingControlCollectionViewCellViewModel: ViewModelProtocol {
  fileprivate let rate: Double
  
  init(rate: Double) {
    self.rate = rate
  }
}

protocol StarRatingControlCollectionCellDelegate: class {
  func didRate(rating: Double)
}

final class StarRatingControlCollectionCell: UICollectionViewCell, Reusable {
  
  weak var delegate: StarRatingControlCollectionCellDelegate?
  
  lazy var ratingView: CosmosView = {
    var view = CosmosView()
    view.settings.filledColor = .accent
    view.settings.emptyBorderColor = .accent
    view.settings.starSize = 44
    view.settings.fillMode = .precise
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(ratingView)
    NSLayoutConstraint.activate([
      ratingView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
      ratingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      ratingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      ratingView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
    ])
    
    ratingView.didFinishTouchingCosmos = { value in //weak self
      self.delegate?.didRate(rating: value)
    }
  }
  
  required init?(coder: NSCoder) { fatalError() }
}

extension StarRatingControlCollectionCell: Decoratable {
  
  typealias ViewModel = StarRatingControlCollectionViewCellViewModel
  
  func decorate(model: ViewModel) {
    ratingView.rating = model.rate
  }
}
