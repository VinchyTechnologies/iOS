//
//  BigAdCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 26.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AdSupport
import AppTrackingTransparency
import Display
import GoogleMobileAds
import UIKit

// MARK: - BigAdCollectionCell

final class BigAdCollectionCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    adBanner.adUnitID = "ca-app-pub-2612888576498887/2728637945"

    backgroundColor = .option

    addSubview(adBanner)
    adBanner.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      adBanner.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      adBanner.leadingAnchor.constraint(equalTo: leadingAnchor),
      adBanner.trailingAnchor.constraint(equalTo: trailingAnchor),
      adBanner.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
    ])

    adBanner.load(GADRequest())

    adBanner.delegate = self
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  let adBanner = GADBannerView(adSize: kGADAdSizeMediumRectangle)
}

// MARK: GADBannerViewDelegate

extension BigAdCollectionCell: GADBannerViewDelegate {
  func adView(_: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
    print(error)
  }
}
