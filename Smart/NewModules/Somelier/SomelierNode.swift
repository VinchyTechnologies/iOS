//
//  SomelierNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit // l
import Display

protocol SomelierNodeDelegate: AnyObject {
    func didTapLikeNode()
    func didTapShareNode()
    func didTapPriceNode()
    func didTapReportError()
    func didTapDislikeNode()
}

struct SomelierNodeViewModel : ViewModelProtocol {
    let imageURLs: [String]
    let title: String
    let description: String
    let isFavourite: Bool
    let isDisliked: Bool
    let price: String
    let options: [DetailOption]
}

final class SomelierNode: ASScrollNode {

    // MARK: - Public Properties

    weak var delegate: SomelierNodeDelegate?

    // MARK: - Private Properties

    private let imageHeaderNode = ProductImagesPagerNode()
    private let titleNode = ASTextNode()
    private let descriptionNode = ASTextNode()
    private let optionsCollectionNode = OptionsCollectionNode()
    private let dislikeNode = ASButtonNode()
    private let tellAboutErrorNode = ASButtonNode()
    private var bottlesNode: MainWineCellNode?


    // MARK: - Initializers

    override init() {
        super.init()

        automaticallyManagesSubnodes = true
        automaticallyManagesContentSize = true

        addSubnode(imageHeaderNode)
        addSubnode(titleNode)

        imageHeaderNode.style.height = .init(unit: .points, value: 300)

        titleNode.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

        descriptionNode.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        addSubnode(optionsCollectionNode)
        optionsCollectionNode.style.height = .init(unit: .points, value: 120)

        tellAboutErrorNode.borderColor = UIColor.dark.cgColor
        tellAboutErrorNode.borderWidth = 2
        tellAboutErrorNode.cornerRadius = 24
        tellAboutErrorNode.style.height = .init(unit: .points, value: 48)
        tellAboutErrorNode.style.width = .init(unit: .points, value: UIScreen.main.bounds.width - 40)
        tellAboutErrorNode.style.alignSelf = .center
        tellAboutErrorNode.setTitle("Задать вопрос", with: Font.regular(18), with: .dark, for: .normal)
        tellAboutErrorNode.setImage(UIImage(systemName: "paperplane"), for: .normal)
        tellAboutErrorNode.addTarget(self, action: #selector(didTapReportError), forControlEvents: .touchUpInside)

        addSubnode(tellAboutErrorNode)
//        bottlesNode = MainWineCellNode(row: MainRow(title: "Я рекомендую", cellType: .bottle, items: bottleItems))
//        if let bottlesNode = bottlesNode {
//            addSubnode(bottlesNode)
//        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        var children: [ASLayoutElement] = [imageHeaderNode, titleNode, tellAboutErrorNode,  descriptionNode, optionsCollectionNode]

        if let bottlesNode = bottlesNode {
            children.append(bottlesNode)
        }

        let vStack = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .start, alignItems: .stretch, children: children)

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return ASInsetLayoutSpec(insets: insets, child: vStack)
    }

    // MARK: - Private Methods

    @objc private func didTapDislikeNode() {
        dislikeNode.isSelected = !dislikeNode.isSelected
        delegate?.didTapDislikeNode()
    }

    @objc private func didTapReportError() {
        delegate?.didTapReportError()
    }
}

extension SomelierNode : Decoratable {

    typealias ViewModel = SomelierNodeViewModel

    func decorate(model: ViewModel) {
        imageHeaderNode.decorate(model: .init(imageURLs: model.imageURLs))
        titleNode.attributedText = NSAttributedString(string: model.title, attributes: ASTextNodeAttributes.common(size: 30))

        let description = NSAttributedString(string: model.description, font: Font.medium(18), textColor: .blueGray)
        descriptionNode.attributedText = description

        dislikeNode.isSelected = model.isDisliked
        optionsCollectionNode.decorate(model: .init(options: model.options))

    }

}
