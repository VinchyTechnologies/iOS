//
//  VinchySize.swift
//  Display
//
//  Created by Aleksei Smirnov on 03.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CoreGraphics

public struct VinchySize {
    
    public enum VinchySizeItem {
        case absolute(CGFloat)
        case dimension(CGFloat)
    }

    public let width: VinchySizeItem
    public let height: VinchySizeItem

    public init(width: VinchySizeItem, height: VinchySizeItem) {
        self.width = width
        self.height = height
    }
}
