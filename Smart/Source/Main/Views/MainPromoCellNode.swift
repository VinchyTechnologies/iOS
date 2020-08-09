//
//  MainPromoCellNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 12.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display

struct MainPromoCellNodeViewModel: ViewModelProtocol {
    let title: String?
    let items: [MainPromoNodeViewModel]
}

final class MainPromoCellNode: ASCellNode {

    weak var delegate: MainViewControllerCellDelegate?

    private let row: MainPromoCellNodeViewModel

    private let collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    private let titleNode = ASTextNode()
    private lazy var collectionNode = ASCollectionNode(collectionViewLayout: collectionViewLayout)

    init(row: MainPromoCellNodeViewModel) {
        self.row = row
        super.init()

        selectionStyle = .none
        collectionNode.contentInset = .init(top: 0, left: 10, bottom: 10, right: 10)
        collectionNode.showsHorizontalScrollIndicator = false

        collectionNode.backgroundColor = .clear
        style.height = .init(unit: .points, value: 140)

        collectionNode.style.flexGrow = 1
        addSubnode(collectionNode)
        addSubnode(titleNode)
        titleNode.textContainerInset = .init(top: 15, left: 10, bottom: 0, right: 10)
        titleNode.attributedText = NSAttributedString(string: row.title ?? "",
                                                      attributes: ASTextNodeAttributes.common(size: 20))
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return ASInsetLayoutSpec(insets: insets, child: collectionNode)
    }
}

extension MainPromoCellNode: ASCollectionDataSource, ASCollectionDelegate {

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return row.items.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        guard let item = row.items[safe: indexPath.row] else { return ASCellNode() }
        return MainPromoNode(.init(imageURL: item.imageURL, title: item.title))
    }

    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCell(indexPath: self.indexPath ?? IndexPath(row: 0, section: 0), itemIndexPath: indexPath)
    }

}
