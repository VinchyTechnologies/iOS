//
//  WineTableCell.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct WineTableCellViewModel: ViewModelProtocol {

    fileprivate let imageURL: String
    fileprivate let title: String
    fileprivate let subtitle: String?

    public init(imageURL: String, title: String, subtitle: String?) {
        self.imageURL = imageURL
        self.title = title
        self.subtitle = subtitle
    }
}

public final class WineTableCell: UITableViewCell {

    private let bottleImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        bottleImageView.translatesAutoresizingMaskIntoConstraints = false
        bottleImageView.contentMode = .scaleAspectFit
        addSubview(bottleImageView)
        NSLayoutConstraint.activate([
            bottleImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 15),
            bottleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bottleImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -15),
            bottleImageView.heightAnchor.constraint(equalToConstant: 100),
            bottleImageView.widthAnchor.constraint(equalToConstant: 40),
            bottleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
        ])

        addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = Font.bold(24)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: bottleImageView.trailingAnchor, constant: 27),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])

        addSubview(subtitleLabel)
        subtitleLabel.textColor = .blueGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = Font.medium(16)
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: bottleImageView.trailingAnchor, constant: 27),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension WineTableCell: Reusable { }

extension WineTableCell: Decoratable {

    public typealias ViewModel = WineTableCellViewModel

    public func decorate(model: ViewModel) {
        bottleImageView.sd_setImage(with: URL(string: model.imageURL)) { [weak self] (image, _, _, _) in
            self?.bottleImageView.image = image?.imageByMakingWhiteBackgroundTransparent()
        }
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
}
