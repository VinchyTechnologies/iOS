//
//  OptionsCollectionNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display

struct DetailOption {
    let title: String
    let subtitle: String
}

struct OptionsCollectionNodeViewModel: ViewModelProtocol {
    let options: [DetailOption]
}

final class OptionsCollectionNode : ASDisplayNode {

    var options: [DetailOption] = [] {
        didSet {
            collectionNode.reloadData()
        }
    }

    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 180, height: 100)
        return layout
    }()

    private lazy var collectionNode = ASCollectionNode(collectionViewLayout: layout)

    override init() {
        super.init()
        collectionNode.backgroundColor = .clear
        collectionNode.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionNode.showsHorizontalScrollIndicator = false
        addSubnode(collectionNode)
        collectionNode.dataSource = self
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: collectionNode)
    }
}

extension OptionsCollectionNode: Decoratable {

    typealias ViewModel = OptionsCollectionNodeViewModel

    func decorate(model: ViewModel) {
        self.options = model.options
    }

}

extension OptionsCollectionNode: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return OptionNode(detailOption: options[indexPath.row])
    }
}

final class OptionNode: ASCellNode {

    private let titleNode = ASTextNode()
    private let subtitleNode = ASTextNode()

    init(detailOption: DetailOption) {
        super.init()

        backgroundColor = .option
        cornerRadius = 15
        addSubnode(titleNode)
        titleNode.maximumNumberOfLines = 2
        addSubnode(subtitleNode)
        subtitleNode.maximumNumberOfLines = 1

        titleNode.attributedText = NSAttributedString(string: detailOption.title,
                                                      attributes: ASTextNodeAttributes.rounded(size: 25))
        subtitleNode.attributedText = NSAttributedString(string: detailOption.subtitle,
                                                         attributes: ASTextNodeAttributes.common(size: 16, textColor: .secondaryLabel))
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let vStack = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .end, alignItems: .stretch, children: [titleNode, subtitleNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: frame.height/2, left: 15, bottom: 10, right: 10), child: vStack)
    }
}
