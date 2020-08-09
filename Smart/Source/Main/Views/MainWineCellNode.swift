//
//  MainWineCellNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 12.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display
import CommonUI

struct MainWineCellNodeViewModel: ViewModelProtocol {
    let title: String?
    let wines: [WineViewCellViewModel]
}

final class MainWineCellNode: ASCellNode {

    weak var delegate: MainViewControllerCellDelegate?

    private let row: MainWineCellNodeViewModel
    private let collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    private let titleNode = ASTextNode()
    private lazy var collectionNode = ASCollectionNode(collectionViewLayout: collectionViewLayout)

    // MARK: - Initializers

    init(row: MainWineCellNodeViewModel) {
        self.row = row
        super.init()

        selectionStyle = .none

        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)

        collectionNode.contentInset = .init(top: 0, left: 20, bottom: 10, right: 20)
        collectionNode.showsHorizontalScrollIndicator = false

        collectionNode.backgroundColor = .clear
        style.height = .init(unit: .points, value: 300)

        collectionNode.style.flexGrow = 1
        addSubnode(collectionNode)
        addSubnode(titleNode)
        titleNode.textContainerInset = .init(top: 15, left: 20, bottom: 0, right: 20)
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

extension MainWineCellNode: ASCollectionDataSource, ASCollectionDelegate {

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return row.wines.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {

        guard let model = row.wines[safe: indexPath.row] else { return ASCellNode() }

        let cell = ASCellNode { () -> UIView in
            let view = WineViewCell()
            view.decorate(model: .init(imageURL: model.imageURL, title: model.title, subtitle: nil))
            view.background.backgroundColor = .option
            return view
        }

        cell.style.width = .init(unit: .points, value: 150)
        cell.style.height = .init(unit: .fraction, value: 1)
        return cell
    }

    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCell(indexPath: self.indexPath ?? IndexPath(row: 0, section: 0), itemIndexPath: indexPath)
    }

}
