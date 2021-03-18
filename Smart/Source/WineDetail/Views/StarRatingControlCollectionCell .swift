//
//  StarRatingControlCollectionCell .swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/8/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import CommonUI

struct StarRatingControlCollectionViewCellViewModel: ViewModelProtocol {
  
  fileprivate let rate: Double
  
  init(rate: Double) {
    self.rate = rate
  }
}

final class StarRatingControlCollectionCell: UICollectionViewCell, Reusable {
  
  private let rateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.with(size: 35, design: .round, traits: .bold)
    label.textColor = .dark
    return label
  }()
    
  private lazy var ratingView: StarCosmosView = {
    var view = StarCosmosView()
    view.settings.filledColor = .accent
    view.settings.emptyBorderColor = .accent
    view.settings.starSize = 32
    view.settings.starMargin = 0
    view.settings.updateOnTouch = false
    view.settings.fillMode = .precise
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(rateLabel)
    rateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      rateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      rateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      rateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
    
    contentView.addSubview(ratingView)
    ratingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingView.leadingAnchor.constraint(equalTo: rateLabel.trailingAnchor, constant: 6),
      ratingView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
      ratingView.centerYAnchor.constraint(equalTo: rateLabel.centerYAnchor),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
}

extension StarRatingControlCollectionCell: Decoratable {
  
  typealias ViewModel = StarRatingControlCollectionViewCellViewModel
  
  func decorate(model: ViewModel) {
    rateLabel.text = String(model.rate)
    ratingView.rating = model.rate
  }
}
