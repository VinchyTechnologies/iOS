//
//  TapToRateCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import Cosmos

struct TapToRateCellViewModel: ViewModelProtocol {
  
  fileprivate let titleText: String?
  fileprivate let rate: Double?
  
  init(titleText: String?, rate: Double?) {
    self.titleText = titleText
    self.rate = rate
  }
}

final class TapToRateCell: UICollectionViewCell, Reusable {
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Font.regular(18)
    label.textColor = .blueGray
    return label
  }()
  
  private lazy var ratingView: CosmosView = {
    let view = CosmosView()
    view.settings.filledColor = .accent
    view.settings.emptyBorderColor = .accent
    view.settings.starSize = 32
    view.settings.fillMode = .half
    view.settings.minTouchRating = 0
    view.rating = 4.5
    view.settings.starMargin = 10
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
        
    contentView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ])
    
    contentView.addSubview(ratingView)
    ratingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      ratingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
}

extension TapToRateCell: Decoratable {
  
  typealias ViewModel = TapToRateCellViewModel
  
  func decorate(model: ViewModel) {
    self.titleLabel.text = model.titleText
    self.ratingView.rating = model.rate ?? 0
  }
}
