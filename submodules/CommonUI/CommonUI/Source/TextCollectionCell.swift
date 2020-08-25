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
    
    public let title: NSAttributedString?

    public init(title: NSAttributedString?) {
        self.title = title
    }
}

public final class TextCollectionCell: UICollectionViewCell, Reusable {

    private let label = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.numberOfLines = 0
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }

    required init?(coder: NSCoder) { fatalError() }
}

extension TextCollectionCell: Decoratable {

    public typealias ViewModel = TextCollectionCellViewModel

    public func decorate(model: TextCollectionCellViewModel) {
        label.attributedText = model.title
    }
}


