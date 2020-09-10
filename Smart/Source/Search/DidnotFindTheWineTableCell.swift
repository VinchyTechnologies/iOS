//
//  DidnotFindTheWineTableCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 19.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

protocol DidnotFindTheWineTableCellProtocol: AnyObject {
    func didTapWriteUsButton(_ button: UIButton)
}

final class DidnotFindTheWineTableCell: UITableViewCell, Reusable {

    weak var delegate: DidnotFindTheWineTableCellProtocol?

    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let writeUsButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Didn't find the wine?" // TODO: - localize
        titleLabel.font = Font.bold(20)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8

        writeUsButton.translatesAutoresizingMaskIntoConstraints = false
        writeUsButton.backgroundColor = .accent
        writeUsButton.setTitle("Write us", for: .normal)
        writeUsButton.setTitleColor(.white, for: .normal)
        writeUsButton.contentEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16)
        writeUsButton.layer.cornerRadius = 10
        writeUsButton.clipsToBounds = true
        writeUsButton.titleLabel?.font = Font.bold(16)
        writeUsButton.addTarget(self, action: #selector(didTapWriteUsButton(_:)), for: .touchUpInside)

        addSubview(writeUsButton)
        NSLayoutConstraint.activate([
            writeUsButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            writeUsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            writeUsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            writeUsButton.heightAnchor.constraint(equalToConstant: 44),
            writeUsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: writeUsButton.leadingAnchor, constant: -10),
        ])


    }

    required init?(coder: NSCoder) { fatalError() }

    @objc
    private func didTapWriteUsButton(_ button: UIButton) {
        delegate?.didTapWriteUsButton(button)
    }
}
