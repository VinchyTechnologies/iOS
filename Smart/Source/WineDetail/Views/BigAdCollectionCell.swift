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

    let adBanner = GADBannerView(adSize: kGADAdSizeMediumRectangle)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .option

        addSubview(adBanner)
        adBanner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adBanner.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            adBanner.leadingAnchor.constraint(equalTo: leadingAnchor),
            adBanner.trailingAnchor.constraint(equalTo: trailingAnchor),
            adBanner.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

}
