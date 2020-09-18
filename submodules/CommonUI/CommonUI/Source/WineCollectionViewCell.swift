//
//  WineCollectionCell.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 05.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import SDWebImage
import Display

public struct WineCollectionViewCellViewModel: ViewModelProtocol, Hashable {
    
    fileprivate let imageURL: URL?
    fileprivate let titleText: String?
    fileprivate let subtitleText: String?
    fileprivate let backgroundColor: UIColor

    public init(imageURL: URL?, titleText: String?, subtitleText: String?, backgroundColor: UIColor) {
        self.imageURL = imageURL
        self.titleText = titleText
        self.subtitleText = subtitleText
        self.backgroundColor = backgroundColor
    }
}

public final class WineCollectionViewCell: HighlightCollectionCell, Reusable {

    private let background = UIView()

    private let bottleImageView: UIImageView = {
        let imageView = UIImageView()
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

        highlightStyle = .scale
        
        background.backgroundColor = .white
        background.layer.cornerRadius = 40

        contentView.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            background.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
        ])

        contentView.addSubview(bottleImageView)
        bottleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottleImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bottleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bottleImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 2/3),
            bottleImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/4),
        ])

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center

        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(UIView())

        stackView.setCustomSpacing(2, after: titleLabel)

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: bottleImageView.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension WineCollectionViewCell: Decoratable {

    public typealias ViewModel = WineCollectionViewCellViewModel

    public func decorate(model: ViewModel) {

        bottleImageView.sd_setImage(with: model.imageURL, placeholderImage: nil, options: .retryFailed) { [weak self] (image, _, _, _) in
            self?.bottleImageView.image = image?.imageByMakingWhiteBackgroundTransparent()
        }

        if let title = model.titleText {
            titleLabel.isHidden = false
            titleLabel.text = title
        } else {
            titleLabel.isHidden = true
        }

        if let subtitle = model.subtitleText {
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
        }

        background.backgroundColor = .option //model.backgroundColor
    }
}
