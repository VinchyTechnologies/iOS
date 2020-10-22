//
//  BigAdCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 26.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import GoogleMobileAds

final class BigAdCollectionCell: UICollectionViewCell, Reusable {

    let adBanner = GADBannerView(adSize: kGADAdSizeLargeBanner)
    
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

    required init?(coder: NSCoder) { fatalError() }

}

extension BigAdCollectionCell: GADBannerViewDelegate {
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
}
