//
//  StoryCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

struct StoryCollectionCellViewModel: ViewModelProtocol {
    let imageURL: String?
    let title: String?
}

final class StoryCollectionCell: UICollectionViewCell, Reusable  {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .option
        layer.cornerRadius = 12
        clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .white
        titleLabel.font = Font.bold(14)

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    private func setAttributedText(string: String) {
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedString.length))

        titleLabel.attributedText = attributedString
    }
}

extension StoryCollectionCell: Decoratable {

    typealias ViewModel = StoryCollectionCellViewModel

    func decorate(model: ViewModel) {
        setAttributedText(string: model.title ?? "")
        imageView.sd_setImage(with: URL(string: model.imageURL ?? ""), placeholderImage: nil, options: .progressiveLoad, completed: nil)
    }
}
