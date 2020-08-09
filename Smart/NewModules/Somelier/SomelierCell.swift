//
//  SomelierCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 04.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

final class SomelierCell: UICollectionViewCell, Reusable {

    private let imageView = UIImageView()
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let brifLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.image = UIImage(named: "person")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: bounds.width),
            imageView.heightAnchor.constraint(equalToConstant: bounds.width)
        ])

        nameLabel.font = Font.regular(20)
        nameLabel.text = "Maria"

        brifLabel.font = Font.regular(16)
        brifLabel.numberOfLines = 2
        brifLabel.textColor = .blueGray
        brifLabel.textAlignment = .center
        brifLabel.text = "Победитель World Wine 2020"

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(brifLabel)

        addSubview(stackView)

    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
        imageView.layer.cornerRadius = bounds.width / 2
        imageView.clipsToBounds = true
    }
}
