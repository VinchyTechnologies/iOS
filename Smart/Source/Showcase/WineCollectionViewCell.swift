//
//  WineCollectionViewCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 14.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import SDWebImage
import Display

struct WineCollectionViewCellViewModel: ViewModelProtocol {
    let imageURL: String
    let title: String?
    let subtitle: String?
}

final class WineCollectionViewCell: UICollectionViewCell {

    public let background = UIView()

    private let bottleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold(16)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.medium(14)
        label.textColor = .blueGray
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .white
        background.layer.cornerRadius = 40
        addSubview(background)
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            background.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9)
        ])

        addSubview(bottleImageView)
        NSLayoutConstraint.activate([
            bottleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottleImageView.topAnchor.constraint(equalTo: topAnchor),
            bottleImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3),
            bottleImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4)
        ])

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center

        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(UIView())

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: bottleImageView.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension WineCollectionViewCell: Decoratable {

    typealias ViewModel = WineCollectionViewCellViewModel

    func decorate(model: ViewModel) {

        bottleImageView.sd_setImage(with: URL(string: model.imageURL)) { [weak self] (image, _, _, _) in
            self?.bottleImageView.image = image?.imageByMakingWhiteBackgroundTransparent()
        }

        if let title = model.title {
            titleLabel.isHidden = false
            titleLabel.text = title
        } else {
            titleLabel.isHidden = true
        }

        if let subtitle = model.subtitle, model.subtitle != "0" { // TODO: - if number of line text is equal to 2
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
        }
    }
}
