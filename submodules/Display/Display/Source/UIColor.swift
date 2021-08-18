//
//  UIColor.swift
//  Display
//
//  Created by Aleksei Smirnov on 17.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

// fileprivate let colors: [UIColor] = [
//    UIColor.rgb(red: 240, green: 227, blue: 223),
//    UIColor.rgb(red: 220, green: 215, blue: 210),
// ]

extension UIColor {
  public final class var mainBackground: UIColor {
    UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
      if UITraitCollection.userInterfaceStyle == .dark {
        return UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1.0)
      } else {
        return .white
      }
    }
  }

  public final class var blueGray: UIColor {
    UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
      if UITraitCollection.userInterfaceStyle == .dark {
        return .secondaryLabel
      } else {
        return UIColor(red: 150 / 255, green: 159 / 255, blue: 179 / 255, alpha: 1.0)
      }
    }
  }

  public final class var dark: UIColor {
    UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
      if UITraitCollection.userInterfaceStyle == .dark {
        return .label
      } else {
        return UIColor(red: 16 / 255, green: 17 / 255, blue: 20 / 255, alpha: 1.0)
      }
    }
  }

  public final class var accent: UIColor {
    UIColor(red: 220 / 255, green: 0 / 255, blue: 33 / 255, alpha: 1.0)
  }

  public final class var option: UIColor {
    UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
      if UITraitCollection.userInterfaceStyle == .dark {
        return UIColor(red: 38 / 255, green: 38 / 255, blue: 41 / 255, alpha: 1.0)
      } else {
        return UIColor(red: 241 / 255, green: 243 / 255, blue: 246 / 255, alpha: 1.0)
      }
    }
  }

  public final class var shimmerLight: UIColor {
    UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
      if UITraitCollection.userInterfaceStyle == .dark {
        return .darkGray
      } else {
        return UIColor(red: 231 / 255, green: 231 / 255, blue: 231 / 255, alpha: 1.0)
      }
    }
  }

  public final class var shimmerAlpha: UIColor {
    UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
      if UITraitCollection.userInterfaceStyle == .dark {
        return .tertiarySystemFill
      } else {
        return UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1.0)
      }
    }
  }
}
