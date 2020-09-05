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
    
    fileprivate let title: NSAttributedString?

    public init(title: NSAttributedString?) {
        self.title = title
    }
}

public final class TextCollectionCell: UICollectionViewCell, Reusable {

    private let label = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    public func getCurrentText() -> String? {
        return label.attributedText?.string
    }
}

extension TextCollectionCell: Decoratable {

    public typealias ViewModel = TextCollectionCellViewModel

    public func decorate(model: TextCollectionCellViewModel) {
        label.attributedText = model.title
    }
}


