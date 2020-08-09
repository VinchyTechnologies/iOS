//
//  MainBigNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 12.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display

struct MainBigNodeViewModel: ViewModelProtocol {

    let imageURL: String
    let title: String

    init(imageURL: String, title: String) {
        self.imageURL = imageURL
        self.title = title
    }
}

final class MainBigNode: ASCellNode {

    // MARK: - Constants

    private enum Constants {
        static let titleNumberOfLines = 2
        static let titleLabelColor: UIColor = .white
        static let cornerRadius: CGFloat = 12
        static let titleLabelFont = Font.bold(14)
        static let titleLineHeightMultiple: CGFloat = 1.22
        static let width: CGFloat = 250
        static let titleInset: CGFloat = 12
    }

    // MARK: - Private Properties

    private let model: MainBigNodeViewModel
    private let imageNode = ASNetworkImageNode()
    private let titleNode = ASTextNode()

    // MARK: - Initializers

    init(_ model: MainBigNodeViewModel) {
        self.model = model
        super.init()

        style.width = .init(unit: .points, value: Constants.width)
        style.height = .init(unit: .fraction, value: 1)

        imageNode.style.flexGrow = 1
        imageNode.contentMode = .scaleToFill
        imageNode.layer.cornerRadius = Constants.cornerRadius
        imageNode.clipsToBounds = true

        titleNode.textContainerInset = .init(top: 0, left: 5, bottom: 0, right: 0)

        addSubnode(imageNode)
        addSubnode(titleNode)

        decorate(model: model)

    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let vStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .spaceBetween, alignItems: .start, children: [imageNode, titleNode])

        return ASInsetLayoutSpec(insets: .zero, child: vStack)
    }

}

extension MainBigNode : Decoratable {

    typealias ViewModel = MainBigNodeViewModel

    func decorate(model: MainBigNodeViewModel) {
        imageNode.setURL(URL(string: model.imageURL), resetToDefault: true)
        titleNode.attributedText = NSAttributedString(string: model.title, attributes: ASTextNodeAttributes.defaultBold(size: 16))
    }
}
