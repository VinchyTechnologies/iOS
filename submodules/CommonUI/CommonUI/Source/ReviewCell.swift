//
//  ReviewCell.swift
//  CommonUI
//
//  Created by Алексей Смирнов on 19.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import Cosmos

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

public final class ReviewCell: HighlightCollectionCell, Reusable {
  
  private let rateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.with(size: 30, design: .round, traits: .bold)
    label.textColor = .dark
    return label
  }()
  
  private lazy var ratingView: CosmosView = {
    var view = CosmosView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.settings.filledColor = .accent
    view.settings.emptyBorderColor = .accent
    view.settings.starSize = 24
    view.settings.fillMode = .half
    view.settings.minTouchRating = 0
    view.settings.starMargin = 0
    view.isUserInteractionEnabled = false
    return view
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = Font.regular(14)
    label.textColor = .blueGray
    return label
  }()
  
  private lazy var textLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .dark
    label.font = Font.regular(15)
    return label
  }()
  
  private let userLabel: UILabel = {
    let label = UILabel()
    label.font = Font.semibold(16)
    label.textColor = .dark
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .option
    layer.cornerRadius = 20
    clipsToBounds = true
    highlightStyle = .scale
    
    contentView.addSubview(rateLabel)
    NSLayoutConstraint.activate([
      rateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
      rateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
    ])
    
    contentView.addSubview(ratingView)
    NSLayoutConstraint.activate([
      ratingView.leadingAnchor.constraint(equalTo: rateLabel.trailingAnchor, constant: 6),
      ratingView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -14),
      ratingView.centerYAnchor.constraint(equalTo: rateLabel.centerYAnchor),
    ])
    
    contentView.addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
      dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
    ])
    
    contentView.addSubview(userLabel)
    userLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      userLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
      userLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
    ])
    
    contentView.addSubview(textLabel)
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textLabel.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 0),
      textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
      textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
      textLabel.bottomAnchor.constraint(lessThanOrEqualTo: userLabel.topAnchor, constant: 0),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
}

extension ReviewCell: Decoratable {
  
  public typealias ViewModel = ReviewCellViewModel
  
  public func decorate(model: ViewModel) {
    ratingView.rating = model.rate ?? 0
    rateLabel.text = String(model.rate ?? 0)
    dateLabel.text = model.dateText
    textLabel.text = model.reviewText
    userLabel.text = model.userNameText
  }
}
