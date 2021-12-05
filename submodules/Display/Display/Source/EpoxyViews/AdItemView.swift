//
//  AdItemView.swift
//  Display
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import GoogleMobileAds
import UIKit

// MARK: - AdItemView

public final class AdItemView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
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

    adBanner.load(GADRequest())

    adBanner.delegate = self
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Public

  public struct Style: Hashable {
    public init() {

    }
  }

  public struct Content: Equatable {
    public init() {

    }
  }

  public static var height: CGFloat {
    adSize.size.height + 40
  }

  public lazy var adBanner = GADBannerView(adSize: AdItemView.adSize)

  // MARK: ContentConfigurableView

  public func setContent(_ content: Content, animated: Bool) {
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
  public func adView(_: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
    print(error)
  }
}
