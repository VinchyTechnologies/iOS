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
  
  private lazy var ratingView: CosmosView = {
    var view = CosmosView()
    view.settings.filledColor = .accent
    view.settings.emptyBorderColor = .accent
    view.settings.starSize = 32
    view.settings.fillMode = .half
    view.settings.minTouchRating = 0
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(ratingView)
    NSLayoutConstraint.activate([
      ratingView.topAnchor.constraint(equalTo: contentView.topAnchor),
      ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
    
    ratingView.didFinishTouchingCosmos = { rating in
      self.delegate?.didRate(rating: rating)
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
