//
//  AdsCollectionViewCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

final class AdsCollectionViewCell: UICollectionViewCell, Reusable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan
    }

    required init?(coder: NSCoder) { fatalError() }
    
}
