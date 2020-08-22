//
//  MainSubtitleCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import SDWebImage
import Display

struct MainSubtitleCollectionCellViewModel: ViewModelProtocol {
    let subtitle: String?
    let imageURL: String?
}

final class MainSubtitleCollectionCell: UICollectionViewCell, Reusable {

    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.backgroundColor = .option
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = Font.semibold(15)
        subtitleLabel.textColor = .blueGray
        addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -3)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension MainSubtitleCollectionCell: Decoratable {

    typealias ViewModel = MainSubtitleCollectionCellViewModel

    func decorate(model: ViewModel) {
        subtitleLabel.text = model.subtitle
        imageView.sd_setImage(with: URL(string: model.imageURL ?? ""))
    }
}
