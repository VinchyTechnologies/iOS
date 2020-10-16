//
//  Font.swift
//  Display
//
//  Created by Aleksei Smirnov on 16.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

public struct Font {

    public enum Design {
        case regular
        case serif
        case monospace
        case round
    }

    public struct Traits: OptionSet {
        public var rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        public init() {
            self.rawValue = 0
        }

        public static let bold = Traits(rawValue: 1 << 0)
        public static let italic = Traits(rawValue: 1 << 1)
    }

    public enum Weight {
        case regular
        case light
        case medium
        case semibold
        case bold
    }

    public static func with(size: CGFloat, design: Design = .regular, traits: Traits = []) -> UIFont {
        let descriptor = UIFont.systemFont(ofSize: size).fontDescriptor
        var symbolicTraits = descriptor.symbolicTraits
        if traits.contains(.bold) {
            symbolicTraits.insert(.traitBold)
        }
        if traits.contains(.italic) {
            symbolicTraits.insert(.traitItalic)
        }
        var updatedDescriptor: UIFontDescriptor? = descriptor.withSymbolicTraits(symbolicTraits)
        switch design {
        case .serif:
            updatedDescriptor = updatedDescriptor?.withDesign(.serif)
        case .monospace:
            updatedDescriptor = updatedDescriptor?.withDesign(.monospaced)
        case .round:
            updatedDescriptor = updatedDescriptor?.withDesign(.rounded)
        default:
            updatedDescriptor = updatedDescriptor?.withDesign(.default)
        }
        if let updatedDescriptor = updatedDescriptor {
            return UIFont(descriptor: updatedDescriptor, size: size)
        } else {
            return UIFont(descriptor: descriptor, size: size)
        }
    }

    public static func regular(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }

    public static func medium(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }

    public static func semibold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    }

    public static func bold(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }

    public static func heavy(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
    }

    public static func light(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
    }

    public static func semiboldItalic(_ size: CGFloat) -> UIFont {
        if let descriptor = UIFont.systemFont(ofSize: size).fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
            return UIFont(descriptor: descriptor, size: size)
        } else {
            return UIFont.italicSystemFont(ofSize: size)
        }
    }

    public static func monospace(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Menlo-Regular", size: size - 1.0) ?? UIFont.systemFont(ofSize: size)
    }

    public static func semiboldMonospace(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Menlo-Bold", size: size - 1.0) ?? UIFont.systemFont(ofSize: size)
    }

    public static func italicMonospace(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Menlo-Italic", size: size - 1.0) ?? UIFont.systemFont(ofSize: size)
    }

    public static func semiboldItalicMonospace(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Menlo-BoldItalic", size: size - 1.0) ?? UIFont.systemFont(ofSize: size)
    }

    public static func italic(_ size: CGFloat) -> UIFont {
        return UIFont.italicSystemFont(ofSize: size)
    }

    public static func dinAlternateBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DINAlternate-Bold", size: size) ?? Font.with(size: size, design: .round, traits: .bold)
    }
}

public extension NSAttributedString {
    convenience init(string: String, font: UIFont? = nil, textColor: UIColor = UIColor.dark, paragraphAlignment: NSTextAlignment? = nil) {
        var attributes: [NSAttributedString.Key: AnyObject] = [:]
        if let font = font {
            attributes[NSAttributedString.Key.font] = font
        }
        attributes[NSAttributedString.Key.foregroundColor] = textColor
        if let paragraphAlignment = paragraphAlignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = paragraphAlignment
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
        self.init(string: string, attributes: attributes)
    }
}

public extension String {

    func height(forWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }

    func height(forWidth width: CGFloat, font: UIFont, numberOfLines: Int) -> CGFloat {
        let result = height(forWidth: width, font: font)
        let maxHeight = font.lineHeight * CGFloat(numberOfLines)
        return min(result, maxHeight)
    }
}

public extension UILabel {

    func applyGradientWith(startColor: UIColor, endColor: UIColor) -> Bool {

        var startColorRed: CGFloat = 0
        var startColorGreen: CGFloat = 0
        var startColorBlue: CGFloat = 0
        var startAlpha: CGFloat = 0

        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return false
        }

        var endColorRed: CGFloat = 0
        var endColorGreen: CGFloat = 0
        var endColorBlue: CGFloat = 0
        var endAlpha: CGFloat = 0

        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return false
        }

        let gradientText = self.text ?? ""

        let textSize: CGSize = gradientText.size(withAttributes: [.font: self.font])
        let width: CGFloat = textSize.width
        let height: CGFloat = textSize.height

        UIGraphicsBeginImageContext(CGSize(width: width, height: height))

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return false
        }

        UIGraphicsPushContext(context)

        let glossGradient: CGGradient?
        let rgbColorspace: CGColorSpace?
        let num_locations: size_t = 2
        let locations: [CGFloat] = [0.0, 1.0]
        let components: [CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        let topCenter = CGPoint.zero
        let bottomCenter = CGPoint(x: 0, y: textSize.height)
        context.drawLinearGradient(glossGradient!, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)

        UIGraphicsPopContext()

        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return false
        }

        UIGraphicsEndImageContext()

        self.textColor = UIColor(patternImage: gradientImage)

        return true
    }

}
