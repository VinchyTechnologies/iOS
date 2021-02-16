//
//  Orientation.swift
//  Display
//
//  Created by Алексей Смирнов on 16.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

public struct Orientation {
    // indicate current device is in the LandScape orientation
  public static var isLandscape: Bool {
        get {
            UIDevice.current.orientation.isValidInterfaceOrientation
                ? UIDevice.current.orientation.isLandscape
                : (UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape)!
        }
    }
    // indicate current device is in the Portrait orientation
  public static var isPortrait: Bool {
        get {
            UIDevice.current.orientation.isValidInterfaceOrientation
                ? UIDevice.current.orientation.isPortrait
                : (UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isPortrait)!
        }
    }
}
