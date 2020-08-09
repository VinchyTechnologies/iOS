//
//  CaruselFilterNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 21.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display
import StringFormatting

protocol CaruselFilterNodeDelegate: AnyObject {
    func didSelectFilter(cell: CaruselFilterNode, title: String)
    func didDeSelectFilter(cell: CaruselFilterNode, title: String)
}

struct CaruselFilterNodeViewModel: ViewModelProtocol {

    struct CaruselFilterItem {
        let title: String
        let imageName: String?
    }

    let items: [CaruselFilterItem]
}

final class CaruselFilterNode: ASCellNode {

    var section: Int?

    weak var delegate: CaruselFilterNodeDelegate?

    var shouldSelect = true

    var items: [CaruselFilterNodeViewModel.CaruselFilterItem] = [] {
        didSet {
            collectionNode.reloadData()
        }
    }

    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 100)
        return layout
    }()

    private lazy var collectionNode = ASCollectionNode(collectionViewLayout: layout)

    override init() {
        super.init()
        style.height = .init(unit: .points, value: 100)
        collectionNode.backgroundColor = .clear
        collectionNode.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionNode.showsHorizontalScrollIndicator = false
        addSubnode(collectionNode)
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: collectionNode)
    }
}

extension CaruselFilterNode: Decoratable {

    typealias ViewModel = CaruselFilterNodeViewModel

    func decorate(model: ViewModel) {
        self.items = model.items
    }

}

extension CaruselFilterNode: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        guard let item = items[safe: indexPath.row] else { return ASCellNode() }
        return CaruselFilterCellNode(filterItem: item)
    }
}

extension CaruselFilterNode: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        if let node = collectionNode.nodeForItem(at: indexPath) as? CaruselFilterCellNode {
            node.didSelected = !node.didSelected
            if node.didSelected {
                delegate?.didSelectFilter(cell: self, title: items[safe: indexPath.row]?.title ?? "")
            } else {
                delegate?.didDeSelectFilter(cell: self, title: items[safe: indexPath.row]?.title ?? "")
            }
        }
    }

    func collectionNode(_ collectionNode: ASCollectionNode, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        shouldSelect
    }
}

final class CaruselFilterCellNode: ASCellNode {

    var didSelected: Bool = false {
        didSet {
            if didSelected {
                borderWidth = 2
                borderColor = UIColor.dark.cgColor
            } else {
                borderWidth = 0
            }
        }
    }

    private let titleNode = ASTextNode()
    private let imageNode = ASImageNode()

    init(filterItem: CaruselFilterNodeViewModel.CaruselFilterItem) {
        super.init()

        backgroundColor = .option //.white
        cornerRadius = 15
        addSubnode(titleNode)
        titleNode.maximumNumberOfLines = 1

        titleNode.attributedText = NSAttributedString(string: localized(filterItem.title).firstLetterUppercased(),
                                                      attributes: ASTextNodeAttributes.rounded(size: 20))
        titleNode.style.maxWidth = .init(unit: .points, value: 100)

        addSubnode(imageNode)
        imageNode.style.maxSize = .init(width: 50, height: 50)
        if let imageName = filterItem.imageName {
            imageNode.image = UIImage(named: imageName)
        }
        imageNode.contentMode = .scaleAspectFill
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let hStack = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .end, alignItems: .center, children: [imageNode])

        let vStack = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .end, alignItems: .stretch, children: [hStack, titleNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15), child: vStack)
    }
}
