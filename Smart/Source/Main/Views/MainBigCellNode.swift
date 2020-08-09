//
//  MainBigCellNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 12.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display

struct MainBigCellNodeViewModel: ViewModelProtocol {
    let title: String?
    let items: [MainBigNodeViewModel]
}

final class MainBigCellNode: ASCellNode {

    weak var delegate: MainViewControllerCellDelegate?
    let row: MainBigCellNodeViewModel

    let collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    private let titleNode = ASTextNode()
    private lazy var collectionNode = ASCollectionNode(collectionViewLayout: collectionViewLayout)

    init(row: MainBigCellNodeViewModel) {
        self.row = row
        super.init()

        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)

        collectionNode.contentInset = .init(top: 0, left: 10, bottom: 10, right: 10)
        collectionNode.showsHorizontalScrollIndicator = false

        collectionNode.backgroundColor = .clear
        style.height = .init(unit: .points, value: 220)

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
        let vStack = ASStackLayoutSpec(direction: .vertical, spacing: 15, justifyContent: .spaceBetween, alignItems: .start, children: [titleNode, collectionNode])
        return ASInsetLayoutSpec(insets: .zero, child: vStack)
    }
}

extension MainBigCellNode: ASCollectionDataSource, ASCollectionDelegate {

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        row.items.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        MainBigNode(.init(imageURL: row.items[indexPath.row].imageURL, title: row.items[indexPath.row].title))
    }

    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCell(indexPath: self.indexPath ?? IndexPath(row: 0, section: 0), itemIndexPath: indexPath)
    }

}
