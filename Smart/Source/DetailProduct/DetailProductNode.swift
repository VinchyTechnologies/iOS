//
//  DetailProductNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 17.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display
import LocationUI
import StringFormatting
import VinchyCore

protocol DetailProductNodeDelegate: AnyObject {
    func didTapLikeNode()
    func didTapShareNode()
    func didTapPriceNode()
    func didTapReportError()
    func didTapDislikeNode()
}

struct DetailProductNodeViewModel: ViewModelProtocol {
    let imageURLs: [String]
    let title: String?
    let description: String?
    let isFavourite: Bool
    let isDisliked: Bool
    let price: String?
    let options: [DetailOption]
    let dishCompatibility: [CaruselFilterNodeViewModel.CaruselFilterItem]
    let place: WinePlace
}

final class DetailProductNode: ASScrollNode {

    weak var delegate: DetailProductNodeDelegate?

    private let imageHeaderNode = ProductImagesPagerNode()
    private let titleNode = ASTextNode()
    private let shareNode = ASButtonNode()
    private let likeNode = ASButtonNode()
    private let priceNode = ASButtonNode()
    private let descriptionNode = ASTextNode()
    private let optionsCollectionNode = OptionsCollectionNode()
    private let mapNode = URLImageNode()
    private let dislikeNode = ASButtonNode()
    private let tellAboutErrorNode = ASButtonNode()
    private var bottlesNode: MainWineCellNode?
    private let tipsNode = ASTextNode()
    private let foodNode = CaruselFilterNode()

    var viewModel: DetailProductNodeViewModel?

    // MARK: - Initializers

    override init() {
        super.init()

        automaticallyManagesSubnodes = true
        automaticallyManagesContentSize = true

        addSubnode(imageHeaderNode)
        addSubnode(titleNode)

        imageHeaderNode.style.height = .init(unit: .points, value: 300)

        titleNode.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

        shareNode.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareNode.style.spacingBefore = 20
        shareNode.style.height = .init(unit: .points, value: 50)
        shareNode.style.width = .init(unit: .points, value: 50)
        shareNode.backgroundColor = .option
        shareNode.cornerRadius = 25
        shareNode.addTarget(self, action: #selector(didTapShareNode), forControlEvents: .touchUpInside)

        likeNode.setImage(UIImage(systemName: "heart"), for: .normal)
        likeNode.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeNode.style.height = .init(unit: .points, value: 50)
        likeNode.style.width = .init(unit: .points, value: 50)
        likeNode.backgroundColor = .option
        likeNode.cornerRadius = 25
        likeNode.addTarget(self, action: #selector(didTapLikeNode), forControlEvents: .touchUpInside)

        priceNode.style.height = .init(unit: .points, value: 50)
        priceNode.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        priceNode.backgroundColor = .option
        priceNode.cornerRadius = 25
        priceNode.style.spacingAfter = 20
        priceNode.addTarget(self, action: #selector(didTapPriceNode), forControlEvents: .touchUpInside)

        descriptionNode.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        addSubnode(optionsCollectionNode)
        optionsCollectionNode.style.height = .init(unit: .points, value: 120)

        addSubnode(mapNode)
        mapNode.layer.borderColor = UIColor.dark.cgColor
        mapNode.layer.borderWidth = 0.2
        mapNode.layer.cornerRadius = 20
        mapNode.clipsToBounds = true
        mapNode.style.height = .init(unit: .points, value: 100)
        mapNode.style.width = .init(unit: .points, value: UIScreen.main.bounds.width - 40)
        mapNode.style.alignSelf = .center
        mapNode.decorate(model: .init(url: buildURL(55.7522200, 37.6155600,
                                             size: CGSize(width: UIScreen.main.bounds.width - 40, height: 100))))


//        dislikeNode.style.spacingBefore = 20
        dislikeNode.borderColor = UIColor.dark.cgColor
        dislikeNode.borderWidth = 2
        dislikeNode.cornerRadius = 24
        dislikeNode.style.height = .init(unit: .points, value: 48)
        dislikeNode.style.width = .init(unit: .points, value: UIScreen.main.bounds.width - 40)
        dislikeNode.style.alignSelf = .center
        dislikeNode.addTarget(self, action: #selector(didTapDislikeNode), forControlEvents: .touchUpInside)

        dislikeNode.setTitle("Dislike", with: Font.bold(18), with: .dark, for: .normal)
        dislikeNode.setImage(UIImage(systemName: "heart.slash"), for: .normal)

        dislikeNode.setTitle("Dislike", with: Font.bold(18), with: .dark, for: .selected)
        dislikeNode.setImage(UIImage(systemName: "heart.slash.fill"), for: .selected)

        addSubnode(dislikeNode)

        tellAboutErrorNode.borderColor = UIColor.dark.cgColor
        tellAboutErrorNode.borderWidth = 2
        tellAboutErrorNode.cornerRadius = 24
        tellAboutErrorNode.style.height = .init(unit: .points, value: 48)
        tellAboutErrorNode.style.width = .init(unit: .points, value: UIScreen.main.bounds.width - 40)
        tellAboutErrorNode.style.alignSelf = .center
        tellAboutErrorNode.setTitle("Сообщить об ошибке", with: Font.bold(18), with: .dark, for: .normal) // TODO
        tellAboutErrorNode.addTarget(self, action: #selector(didTapReportError), forControlEvents: .touchUpInside)

        tipsNode.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        tipsNode.attributedText = NSAttributedString(string: "Serving tips", // TODO - 
                                                     attributes: ASTextNodeAttributes.common(size: 20))
        addSubnode(tipsNode)

        addSubnode(foodNode)
        // .init(items: [CaruselFilterNodeViewModel.CaruselFilterItem(title: "Meat", imageName: "meat")
        foodNode.style.spacingBefore = -10
        foodNode.style.spacingAfter = 20
        foodNode.shouldSelect = false

        addSubnode(tellAboutErrorNode)
//        bottlesNode = MainWineCellNode(row: MainRow(title: localized("you_can_also_like").firstLetterUppercased(), cellType: .bottle, items: bottleItems))
//        if let bottlesNode = bottlesNode {
//            addSubnode(bottlesNode)
//        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        var hStackChildren = [shareNode, likeNode]
        if let _ = viewModel?.price {
            hStackChildren.append(priceNode)
        }

        let hStack = ASStackLayoutSpec(direction: .horizontal, spacing: 20, justifyContent: .spaceBetween, alignItems: .stretch, children: hStackChildren)


        var children: [ASLayoutElement] = [imageHeaderNode, titleNode, hStack, descriptionNode]

        if viewModel?.options.isEmpty == false {
            children.append(optionsCollectionNode)
        }

        if viewModel?.dishCompatibility.isEmpty == false {
            children += [tipsNode, foodNode]
        }

        if let lat = viewModel?.place.lat, let lon = viewModel?.place.lon {
            children.append(mapNode)
        }

        children += [dislikeNode, tellAboutErrorNode]

        if let bottlesNode = bottlesNode {
            children.append(bottlesNode)
        }

        let vStack = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .start, alignItems: .stretch, children: children)

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return ASInsetLayoutSpec(insets: insets, child: vStack)
    }

    @objc private func didTapLikeNode() {
        likeNode.isSelected = !likeNode.isSelected
        delegate?.didTapLikeNode()
    }

    @objc private func didTapDislikeNode() {
        dislikeNode.isSelected = !dislikeNode.isSelected
        delegate?.didTapDislikeNode()
    }

    @objc private func didTapShareNode() {
        delegate?.didTapShareNode()
    }

    @objc private func didTapPriceNode() {
        delegate?.didTapPriceNode()
    }

    @objc private func didTapReportError() {
        delegate?.didTapReportError()
    }

    func addBottleItems() {

    }
}

extension DetailProductNode: Decoratable {

    typealias ViewModel = DetailProductNodeViewModel

    func decorate(model: ViewModel) {
        self.viewModel = model
        imageHeaderNode.decorate(model: .init(imageURLs: model.imageURLs))
        priceNode.setTitle(model.price ?? "?", with: Font.dinAlternateBold(25), with: .dark, for: .normal)
        titleNode.attributedText = NSAttributedString(string: model.title ?? "Unknown", attributes: ASTextNodeAttributes.common(size: 20))


        let description = NSAttributedString(string: model.description ?? "", font: Font.light(16))
        descriptionNode.attributedText = description

        likeNode.isSelected = model.isFavourite
        dislikeNode.isSelected = model.isDisliked

        optionsCollectionNode.decorate(model: .init(options: model.options))

        if model.dishCompatibility.isEmpty {
            foodNode.removeFromSupernode()
        }

        foodNode.decorate(model: .init(items: model.dishCompatibility))

//        layout()
    }

}

//let bottleItems: [MainItem] = [
//
//    MainItem(itemId: "1", width: 320, transitionType: .category, imageURL: "https://media.danmurphys.com.au/dmo/product/464845-1.png", title: "Dom Perignion", subtitle: "France, Burgundia"),
//    MainItem(itemId: "1", width: 320, transitionType: .category, imageURL: "https://media.danmurphys.com.au/dmo/product/464845-1.png", title: "Франция", subtitle: nil),
//    MainItem(itemId: "1", width: 320, transitionType: .category, imageURL: "https://media.danmurphys.com.au/dmo/product/464845-1.png", title: "Франция", subtitle: "Italy"),
//    MainItem(itemId: "1", width: 320, transitionType: .category, imageURL: "https://media.danmurphys.com.au/dmo/product/464845-1.png", title: "Франция", subtitle: "France"),
//    MainItem(itemId: "1", width: 320, transitionType: .category, imageURL: "https://media.danmurphys.com.au/dmo/product/464845-1.png", title: "Франция", subtitle: "NY"),
//
//]
