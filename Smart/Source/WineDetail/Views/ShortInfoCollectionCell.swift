//
//  ShortInfoCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 25.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

struct ShortInfoCollectionCellViewModel: ViewModelProtocol {

    fileprivate let title: NSAttributedString?
    fileprivate let subtitle: NSAttributedString?

    public init(title: NSAttributedString?, subtitle: NSAttributedString?) {
        self.title = title
        self.subtitle = subtitle
    }
}

final class ShortInfoCollectionCell: UICollectionViewCell, Reusable {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .option

        layer.cornerRadius = 15

        [titleLabel, subtitleLabel].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })

        addSubview(titleLabel)
        addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),

            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])

    }

    required init?(coder: NSCoder) { fatalError() }

}

extension ShortInfoCollectionCell: Decoratable {

    typealias ViewModel = ShortInfoCollectionCellViewModel

    func decorate(model: ViewModel) {
        titleLabel.attributedText = model.title
        subtitleLabel.attributedText = model.subtitle
    }
}
