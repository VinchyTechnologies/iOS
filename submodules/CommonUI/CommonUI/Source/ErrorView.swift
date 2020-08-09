//
//  ErrorView.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public protocol ErrorViewDelegate: AnyObject {
    func didTapErrorButton(_ button: UIButton)
}

public final class ErrorView: UIView {

    // MARK: - Public Properties

    public weak var delegate: ErrorViewDelegate?
    public var isButtonHidden: Bool = false {
        didSet {
            refreshButton.isHidden = isButtonHidden
        }
    }

    // MARK: - Private Properties

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let refreshButton = UIButton()

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)

        [titleLabel, subtitleLabel, refreshButton].forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })

        titleLabel.font = Font.bold(24)
        titleLabel.textAlignment = .center

        subtitleLabel.font = Font.medium(18)
        subtitleLabel.textColor = .blueGray
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 3

        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.titleLabel?.font = Font.bold(18)
        refreshButton.backgroundColor = .accent
        refreshButton.layer.cornerRadius = 26
        refreshButton.clipsToBounds = true

        refreshButton.addTarget(self, action: #selector(didTapErrorButton(_:)), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(refreshButton)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            refreshButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            refreshButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 250),
            refreshButton.heightAnchor.constraint(equalToConstant: 52)
        ])

    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public Methods

    public func configure(title: String?, description: String?, buttonText: String) {
        titleLabel.text = title
        subtitleLabel.text = description
        refreshButton.setTitle(buttonText, for: .normal)
    }

    // MARK: - Private Properties

    @objc private func didTapErrorButton(_ button: UIButton) {
        delegate?.didTapErrorButton(button)
    }

}
