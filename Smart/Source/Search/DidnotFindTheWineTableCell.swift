//
//  DidnotFindTheWineTableCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 19.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

final class DidnotFindTheWineTableCell: UITableViewCell {

    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let writeUsButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.text = "Didn't find the wine?"
        titleLabel.font = Font.bold(20)

        stackView.axis = .horizontal
        stackView.addArrangedSubview(titleLabel)

        addSubview(stackView)
        stackView.frame = bounds

    }

    required init?(coder: NSCoder) { fatalError() }
}
