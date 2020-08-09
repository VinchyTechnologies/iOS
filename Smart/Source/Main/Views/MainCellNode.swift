//
//  MainCellNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display

struct MainCellNodeViewModel: ViewModelProtocol {
    let title: String?
    let items: [MainMiniNodeViewModel]
}

final class MainCellNode: ASCellNode {

    // MARK: - Public Properties

    weak var delegate: MainViewControllerCellDelegate?

    // MARK: - Private Properties

    private let row: MainCellNodeViewModel

    private let collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var collectionNode = ASCollectionNode(collectionViewLayout: collectionViewLayout)

    // MARK: - Initializers

    init(row: MainCellNodeViewModel) {
        self.row = row
        super.init()
        selectionStyle = .none

        collectionNode.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        collectionNode.showsHorizontalScrollIndicator = false
        collectionNode.backgroundColor = .clear
        style.height = .init(unit: .points, value: 155)
        addSubnode(collectionNode)
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return ASInsetLayoutSpec(insets: insets, child: collectionNode)
    }
}

extension MainCellNode: ASCollectionDataSource, ASCollectionDelegate {

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        row.items.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        MainMiniNode(.init(imageURL: row.items[indexPath.row].imageURL, title: row.items[indexPath.row].title))
    }

    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCell(indexPath: self.indexPath ?? IndexPath(row: 0, section: 0), itemIndexPath: indexPath)
    }

}
