//
//  ButtonCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 26.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

struct ButtonCollectionCellViewModel: ViewModelProtocol {

    fileprivate let normalImage: UIImage?
    fileprivate let selectedImage: UIImage?
    fileprivate let title: NSAttributedString?
    fileprivate let type: ButtonCollectionCellType

    public init(normalImage: UIImage?, selectedImage: UIImage?, title: NSAttributedString?, type: ButtonCollectionCellType) {
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.title = title
        self.type = type
    }
}

enum ButtonCollectionCellType {
    case dislike, reportAnError
}

protocol ButtonCollectionCellDelegate: AnyObject {
    func didTapButtonCollectionCell(_ button: UIButton, type: ButtonCollectionCellType)
}

final class ButtonCollectionCell: UICollectionViewCell, Reusable {

    weak var delegate: ButtonCollectionCellDelegate?

    private var type: ButtonCollectionCellType?
    internal let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.dark.cgColor
        button.tintColor = .dark
        button.imageEdgeInsets = .init(top: 0, left: -10, bottom: 0, right: 10)
        button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        addSubview(button)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = bounds
        button.layer.cornerRadius = bounds.height / 2
        button.clipsToBounds = true
    }

    @objc
    private func didTap(_ button: UIButton) {
        guard let type = type else { return }
        delegate?.didTapButtonCollectionCell(button, type: type)
    }
}

extension ButtonCollectionCell: Decoratable {

    typealias ViewModel = ButtonCollectionCellViewModel

    func decorate(model: ButtonCollectionCellViewModel) {
        if let normalImage = model.normalImage {
            button.setImage(normalImage, for: .normal)
        } else {
            button.setImage(nil, for: .normal)
        }

        if let selectedImage = model.selectedImage {
            button.setImage(selectedImage, for: .selected)
        } else {
            button.setImage(nil, for: .selected)
        }

        button.setAttributedTitle(model.title, for: .normal)

        self.type = model.type
    }
}
