//
//  ASTextNodeAttributes.swift
//  Display
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

// TODO: - Delete all
public enum ASTextNodeAttributes {

    public static func defaultBold(size: CGFloat) -> [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: size)]
    }

    public static func rounded(size: CGFloat, textColor: UIColor = .dark) -> [NSAttributedString.Key : Any] {
        return [
            NSAttributedString.Key.font: Font.with(size: size, design: .round, traits: .bold),
            NSAttributedString.Key.foregroundColor: textColor
        ]
    }

    public static func common(size: CGFloat, textColor: UIColor = .dark) -> [NSAttributedString.Key : Any] {
        return [
            NSAttributedString.Key.font: Font.bold(size),
            NSAttributedString.Key.foregroundColor: textColor
        ]
    }
}
