//
//  ToolCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 25.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

struct ToolCollectionCellViewModel: ViewModelProtocol {
    let price: String?
    let isLiked: Bool
}

final class ToolCollectionCell: UICollectionViewCell, Reusable {

    private let shareButton = UIButton()
    private let likeButton = UIButton()
    private let priceButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        [shareButton, likeButton, priceButton].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .option
            $0.layer.cornerRadius = 25
            $0.clipsToBounds = true
        })

        addSubview(shareButton)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig), for: .normal)
        shareButton.tintColor = .dark
        addSubview(priceButton)
        priceButton.contentEdgeInsets = .init(top: 0, left: 18, bottom: 0, right: 18)

        let spaceBetweenShareAndPrice = UILayoutGuide()
        addLayoutGuide(spaceBetweenShareAndPrice)

        addSubview(likeButton)
        likeButton.tintColor = .dark
        likeButton.setImage(UIImage(systemName: "heart", withConfiguration: imageConfig), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: imageConfig), for: .selected)

        NSLayoutConstraint.activate([
            shareButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            priceButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceButton.heightAnchor.constraint(equalToConstant: 50),
            priceButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            spaceBetweenShareAndPrice.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor),
            spaceBetweenShareAndPrice.trailingAnchor.constraint(equalTo: priceButton.leadingAnchor),
            spaceBetweenShareAndPrice.heightAnchor.constraint(equalTo: heightAnchor),

            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            likeButton.centerXAnchor.constraint(equalTo: spaceBetweenShareAndPrice.centerXAnchor),
            likeButton.centerYAnchor.constraint(equalTo: spaceBetweenShareAndPrice.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension ToolCollectionCell: Decoratable {

    typealias ViewModel = ToolCollectionCellViewModel

    func decorate(model: ViewModel) {
        let title = NSAttributedString(string: model.price ?? "", font: Font.with(size: 20, design: .round, traits: .bold), textColor: .dark, paragraphAlignment: .center)
        priceButton.setAttributedTitle(title, for: .normal)
        likeButton.isSelected = model.isLiked
    }
}
