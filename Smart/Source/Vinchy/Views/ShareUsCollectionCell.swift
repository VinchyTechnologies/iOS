//
//  ShareUsCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 07.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct ShareUsCollectionCellViewModel: ViewModelProtocol, Hashable {

    fileprivate let titleText: String?

    public init(titleText: String?) {
        self.titleText = titleText
    }
    
}

final class ShareUsCollectionCell: UICollectionViewCell, Reusable {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .mainBackground

        layer.cornerRadius = 24
        clipsToBounds = true
        layer.masksToBounds = false

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5

        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
    

        titleLabel.font = Font.with(size: 24, design: .round, traits: .bold)
        titleLabel.textColor = .dark

        subtitleLabel.text = "Tell us all over the world!"
        subtitleLabel.font = Font.bold(18)
        subtitleLabel.textColor = .blueGray

        button.backgroundColor = .accent
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.widthAnchor.constraint(equalToConstant: frame.width - 40).isActive = true
        button.setTitle("Share link", for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true

        [titleLabel, subtitleLabel].forEach({ $0.numberOfLines = 0 })

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(button)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension ShareUsCollectionCell: Decoratable {

    typealias ViewModel = ShareUsCollectionCellViewModel

    func decorate(model: ViewModel) {
        self.titleLabel.text = model.titleText
    }


}
