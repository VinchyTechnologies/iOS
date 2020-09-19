//
//  SuggestionCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 21.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

struct SuggestionCollectionCellViewModel: ViewModelProtocol, Hashable {

    fileprivate let titleText: String?

    public init(titleText: String?) {
        self.titleText = titleText
    }
}

final class SuggestionCollectionCell: UICollectionViewCell, Reusable {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.font = Font.bold(18)
        label.textColor = .blueGray
        addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension SuggestionCollectionCell: Decoratable {

    typealias ViewModel = SuggestionCollectionCellViewModel

    func decorate(model: ViewModel) {
        label.text = model.titleText
    }

}
