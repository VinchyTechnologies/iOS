//
//  SmartImageNode.swift
//  Display
//
//  Created by Aleksei Smirnov on 28.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import SDWebImage

/// removing white space
public final class SmartImageNode: ASDisplayNode {

    public let imageView = UIImageView()

    public override init() {
        super.init()
        view.addSubview(imageView)
    }

    public override func layout() {
        super.layout()
        imageView.frame = bounds
    }

    public func load(url: String) {
        imageView.sd_setImage(with: URL(string: url)) { [weak self] (image, _, _, _) in
            self?.imageView.image = image?.imageByMakingWhiteBackgroundTransparent()
        }
    }

}
