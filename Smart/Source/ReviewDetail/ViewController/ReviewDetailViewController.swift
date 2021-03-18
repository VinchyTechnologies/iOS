//
//  ReviewDetailViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import UIKit
import FittedSheets

final class ReviewDetailViewController: UIViewController {
  
  var interactor: ReviewDetailInteractorProtocol?
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    scrollView.backgroundColor = .mainBackground
    return scrollView
  }()
  
  private let rateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.with(size: 30, design: .round, traits: .bold)
    label.textColor = .dark
    return label
  }()
  
  private lazy var ratingView: StarCosmosView = {
    var view = StarCosmosView()
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
  
  private let authorLabel: UILabel = {
    let label = UILabel()
    label.font = Font.heavy(20)
    label.textColor = .dark
    return label
  }()
  
  private let reviewLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = Font.regular(18)
    label.textColor = .dark
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = Font.bold(16)
    label.textColor = .blueGray
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sheetViewController?.handleScrollView(self.scrollView)
    if traitCollection.userInterfaceStyle == .dark {
      sheetViewController?.gripColor = .blueGray
    }
    
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    
    scrollView.addSubview(rateLabel)
    NSLayoutConstraint.activate([
      rateLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
      rateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    ])
    
    scrollView.addSubview(ratingView)
    NSLayoutConstraint.activate([
      ratingView.leadingAnchor.constraint(equalTo: rateLabel.trailingAnchor, constant: 6),
      ratingView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
      ratingView.centerYAnchor.constraint(equalTo: rateLabel.centerYAnchor),
    ])
    
    scrollView.addSubview(authorLabel)
    authorLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      authorLabel.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 6),
      authorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
      authorLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
    ])
    
    scrollView.addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -16),
      dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
    
    scrollView.addSubview(reviewLabel)
    reviewLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      reviewLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
      reviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      reviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: dateLabel.topAnchor, constant: -16),
      reviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
    
    interactor?.viewDidLoad()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if traitCollection.userInterfaceStyle == .dark {
      sheetViewController?.gripColor = .blueGray
    } else {
      sheetViewController?.gripColor = SheetViewController.gripColor
    }
  }
}

// MARK: - ReviewDetailViewControllerProtocol

extension ReviewDetailViewController: ReviewDetailViewControllerProtocol {
  func updateUI(viewModel: ReviewDetailViewModel) {
    ratingView.rating = viewModel.rate ?? 0
    rateLabel.text = String(viewModel.rate ?? 0)
    authorLabel.text = viewModel.authorText
    dateLabel.text = viewModel.dateText
    
    guard let string = viewModel.reviewText else { return }
    let attributedString = NSMutableAttributedString(string: string)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.25
    attributedString.addAttribute(
      NSAttributedString.Key.paragraphStyle,
      value: paragraphStyle,
      range: NSRange(location: 0, length: attributedString.length))
    reviewLabel.attributedText = attributedString
  }
}
