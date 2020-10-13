//
//  AdsCollectionViewCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import GoogleMobileAds
import VinchyCore

extension GADUnifiedNativeAd: AdsProtocol { }

final class AdsCollectionViewCell: UICollectionViewCell, Reusable {

    let adView = GADTMediumTemplateView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground
        addSubview(adView)
        let styles: [GADTNativeTemplateStyleKey: NSObject] = [
            .callToActionFont: UIFont.boldSystemFont(ofSize: 15),
            .callToActionFontColor: UIColor.white,
            .callToActionBackgroundColor: UIColor.accent,
            .secondaryFont: UIFont.systemFont(ofSize: 15),
            .secondaryFontColor: UIColor.blueGray,
            .secondaryBackgroundColor: UIColor.mainBackground,
            .primaryFont: UIFont.boldSystemFont(ofSize: 15),
            .primaryFontColor: UIColor.black,
            .primaryBackgroundColor: UIColor.white,
            .tertiaryFont: UIFont.systemFont(ofSize: 15),
            .tertiaryFontColor: UIColor.blueGray,
            .tertiaryBackgroundColor: UIColor.white,
            .mainBackgroundColor: UIColor.white,
            .cornerRadius: NSNumber(value: 7.0),
        ]

        adView.styles = styles

        adView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: topAnchor),
            adView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.5),
            adView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0.5),
            adView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        adView.nativeAd = nil
    }
    
}
