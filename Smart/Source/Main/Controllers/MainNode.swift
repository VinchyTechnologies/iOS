//
//  MainNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 27.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display

final class MainNode: ASDisplayNode {

    let tableNode = ASTableNode()
    let footerLabel = UILabel(frame: .init(x: 20, y: 0, width: UIScreen.main.bounds.width - 40, height: 50))

    override init() {
        super.init()
        addSubnode(tableNode)
        tableNode.backgroundColor = .mainBackground

        footerLabel.numberOfLines = 2
        footerLabel.textColor = .blueGray
        footerLabel.font = Font.light(15)
        footerLabel.text = "Чрезмерное употребление алкоголя\nвредит вашему здоровью"
        tableNode.view.tableFooterView = footerLabel
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: tableNode)
    }
}
