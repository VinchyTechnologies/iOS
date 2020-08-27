//
//  ImageOptionCollectionCell.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 27.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct ImageOptionCollectionCellViewModel: ViewModelProtocol {
    public let imageName: String
    public let title: String?

    public init(imageName: String, title: String?) {
        self.imageName = imageName
        self.title = title
    }
}

public final class ImageOptionCollectionCell: UICollectionViewCell, Reusable {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .option
        layer.cornerRadius = 15
        clipsToBounds = true

        [imageView, titleLabel].forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })

        titleLabel.font = Font.with(size: 20, design: .round, traits: .bold)
        titleLabel.textColor = .dark

        imageView.tintColor = .dark

        addSubview(imageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 130)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension ImageOptionCollectionCell: Decoratable {

    public typealias ViewModel = ImageOptionCollectionCellViewModel

    public func decorate(model: ViewModel) {
        imageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title
    }
}
