//
//  MoreBounceDecoratorView.swift
//  Smart
//
//  Created by Aleksei Smirnov on 14.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

struct MoreBounceDecoratorViewModel: ViewModelProtocol {
    let titleText: String?
}

final class MoreBounceDecoratorView: UIView {

    private let label = PaddingLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .accent
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 50),
            heightAnchor.constraint(equalToConstant: 50),
        ])

        label.font = Font.heavy(14)
        label.textColor = .white
        label.textAlignment = .center

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.fill()

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension MoreBounceDecoratorView: Decoratable {

    typealias ViewModel = MoreBounceDecoratorViewModel

    func decorate(model: ViewModel) {
        label.text = model.titleText
    }
}

