//
//  AdItemView.swift
//  Smart
//
//  Created by Алексей Смирнов on 27.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Epoxy
import UIKit

// MARK: - AdItemView

final class AdItemView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

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

    adBanner.delegate = self
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Internal

  struct Style: Hashable {
  }

  struct Content: Equatable {
  }

  static var height: CGFloat {
    adSize.size.height + 40
  }

  lazy var adBanner = GADBannerView(adSize: AdItemView.adSize)

  // MARK: ContentConfigurableView

  func setContent(_ content: Content, animated: Bool) {
    adBanner.load(GADRequest())
    isUserInteractionEnabled = true
    adBanner.isUserInteractionEnabled = true
    setNeedsLayout()
    layoutIfNeeded()
  }

  // MARK: Private

  private static var adSize: GADAdSize = kGADAdSizeMediumRectangle
}

// MARK: GADBannerViewDelegate

extension AdItemView: GADBannerViewDelegate {
  func adView(_: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
    print(error)
  }
}
