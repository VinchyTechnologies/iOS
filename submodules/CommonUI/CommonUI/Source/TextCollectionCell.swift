//
//  TextCollectionCell.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 25.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct TextCollectionCellViewModel: ViewModelProtocol {
    
    fileprivate let titleText: NSAttributedString?

    public init(titleText: NSAttributedString?) {
        self.titleText = titleText
    }
}

public final class TextCollectionCell: UICollectionViewCell, Reusable {

    private let label = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.numberOfLines = 0

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    public func getCurrentText() -> String? {
        label.attributedText?.string
    }

    public static func height(viewModel: ViewModel, width: CGFloat) -> CGFloat {
        // swiftlint:disable:next force_cast
        let font = viewModel.titleText?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.font] as? UIFont ?? Font.regular(14)
        let height = viewModel.titleText?.string.height(forWidth: width, font: font) ?? 44
        return height
    }
}

extension TextCollectionCell: Decoratable {

    public typealias ViewModel = TextCollectionCellViewModel

    public func decorate(model: ViewModel) {
        label.attributedText = model.titleText
    }
}
