//
//  Emoji.swift
//  Core
//
//  Created by Aleksei Smirnov on 15.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

//public func emojiFlag(countryCode: String) -> String {
//    countryCode
//        .uppercased()
//        .unicodeScalars
//        .map({ 127397 + $0.value })
//        .compactMap(UnicodeScalar.init)
//        .map(String.init)
//        .joined()
//}
//
//public func emojiFlagImage(countryCode: String) -> UIImage? {
//    emojiFlag(countryCode: countryCode).toImage()
//}
//
//fileprivate extension String {
//    func toImage(size: CGSize = CGSize(width: 60, height: 40), fontSize: CGFloat = 40) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        UIColor.clear.set()
//        let rect = CGRect(origin: .zero, size: size)
//        UIRectFill(CGRect(origin: .zero, size: size))
//        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: fontSize)])
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
//}
