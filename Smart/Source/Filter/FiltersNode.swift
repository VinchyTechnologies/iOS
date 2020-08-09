//
//  FiltersNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 21.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display
import StringFormatting

final class FiltersNode: ASDisplayNode {

    private(set) var isButtonShown: Bool = false
    let tableNode = ASTableNode(style: .grouped)
    lazy var searchButton = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 40, height: 48))

    override init() {
        super.init()

        tableNode.backgroundColor = .mainBackground
        tableNode.view.separatorStyle = .none

        addSubnode(tableNode)
        tableNode.view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 68))
        tableNode.view.tableHeaderView = UIView(frame: .init(0, 0, 0, .leastNormalMagnitude))

        searchButton.setTitle(localized("search").firstLetterUppercased(), for: .normal)
        searchButton.titleLabel?.font = Font.bold(18)
        searchButton.backgroundColor = .accent
        searchButton.layer.cornerRadius = 24
        searchButton.clipsToBounds = true

        view.addSubview(searchButton)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        ASInsetLayoutSpec(insets: .zero, child: tableNode)
    }

    func showButton() {
        isButtonShown = true

        UIView.animate(withDuration: 0.25, animations: {
            let frame = CGRect(x: 20, y: self.view.safeAreaLayoutGuide.layoutFrame.maxY - 58, width: UIScreen.main.bounds.width - 40, height: 48)
            self.searchButton.frame = frame
            self.layoutIfNeeded()
        }, completion: nil)
    }

    func hideButton() {
        isButtonShown = false

        UIView.animate(withDuration: 0.25, animations: {
            let frame = CGRect(x: 20, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 40, height: 48)
            self.searchButton.frame = frame
            self.layoutIfNeeded()
        }, completion: nil)
    }

}
