//
//  UIColor.swift
//  Display
//
//  Created by Aleksei Smirnov on 17.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

//fileprivate let colors: [UIColor] = [
//    UIColor.rgb(red: 240, green: 227, blue: 223),
//    UIColor.rgb(red: 220, green: 215, blue: 210),
//]

extension UIColor {

    public final class var mainBackground: UIColor {
        .systemBackground
    }

    public final class var blueGray: UIColor {
        UIColor.rgb(red: 150, green: 159, blue: 179, alpha: 1.0)
    }

    public final class var dark: UIColor {
        UIColor.rgb(red: 16, green: 17, blue: 20, alpha: 1.0)
    }

    public final class var accent: UIColor {
        UIColor.rgb(red: 220, green: 0, blue: 33)
    }

    public final class var option: UIColor {
        UIColor(red: 241 / 255, green: 243 / 255, blue: 246 / 255, alpha: 1.0)
    }
}
