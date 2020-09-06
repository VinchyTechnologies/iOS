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

    fileprivate let price: String?
    fileprivate let isLiked: Bool

    public init(price: String?, isLiked: Bool) {
        self.price = price
        self.isLiked = isLiked
    }
}

protocol ToolCollectionCellDelegate: AnyObject {
    func didTapShare(_ button: UIButton)
    func didTapLike(_ button: UIButton)
    func didTapPrice(_ button: UIButton)
}

final class ToolCollectionCell: UICollectionViewCell, Reusable {

    weak var delegate: ToolCollectionCellDelegate?

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
        shareButton.addTarget(self, action: #selector(didTapShareButton(_:)), for: .touchUpInside)

        addSubview(priceButton)
        priceButton.backgroundColor = .accent
        priceButton.contentEdgeInsets = .init(top: 0, left: 18, bottom: 0, right: 18)
        priceButton.addTarget(self, action: #selector(didTapPriceButton(_:)), for: .touchUpInside)

        let spaceBetweenShareAndPrice = UILayoutGuide()
        addLayoutGuide(spaceBetweenShareAndPrice)

        addSubview(likeButton)
        likeButton.tintColor = .dark
        likeButton.setImage(UIImage(systemName: "heart", withConfiguration: imageConfig), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: imageConfig), for: .selected)
        likeButton.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)

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
            likeButton.centerYAnchor.constraint(equalTo: spaceBetweenShareAndPrice.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc
    private func didTapShareButton(_ button: UIButton) {
        delegate?.didTapShare(button)
    }

    @objc
    private func didTapPriceButton(_ button: UIButton) {
        delegate?.didTapPrice(button)
    }

    @objc
    private func didTapLikeButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        delegate?.didTapLike(button)
    }

}

extension ToolCollectionCell: Decoratable {

    typealias ViewModel = ToolCollectionCellViewModel

    func decorate(model: ViewModel) {
        let title = NSAttributedString(string: model.price ?? "", font: Font.with(size: 20, design: .round, traits: .bold), textColor: .white, paragraphAlignment: .center)
        priceButton.setAttributedTitle(title, for: .normal)
        likeButton.isSelected = model.isLiked
    }
}
