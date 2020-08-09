//
//  ProductImagesPagerNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display

struct ProductImagesPagerNodeViewModel: ViewModelProtocol {

    let imageURLs: [String]

    init(imageURLs: [String]) {
        self.imageURLs = imageURLs
    }
}

final class ProductImagesPagerNode: ASDisplayNode {

    let collectionViewLayout: ASPagerFlowLayout = {
        let collectionViewLayout = ASPagerFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.scrollDirection = .horizontal
        return collectionViewLayout
    }()

    lazy var pagerNode = ASPagerNode(collectionViewLayout: collectionViewLayout)
    let control = ASPageControl(frame: CGRect(x: 0,
                                              y: 300 - 20,
                                              width: UIScreen.main.bounds.width,
                                              height: 20))

    private var imageUrls: [String] = [] {
        didSet {
            control.numberOfPages = imageUrls.count
            pagerNode.reloadData()
        }
    }

    override init() {
        super.init()

        pagerNode.backgroundColor = .mainBackground

        pagerNode.allowsAutomaticInsetsAdjustment = true

        addSubnode(pagerNode)

        addSubnode(ASDisplayNode(viewBlock: {
            self.control.hidesForSinglePage = true
            return self.control
        }))

        pagerNode.setDataSource(self)
        pagerNode.setDelegate(self)

    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return ASInsetLayoutSpec(insets: insets, child: pagerNode)
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

}

extension ProductImagesPagerNode: ASPagerDataSource, ASPagerDelegate {

    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        imageUrls.count
    }

    func pagerNode(_ pagerNode: ASPagerNode, nodeAt index: Int) -> ASCellNode {
        return ImageNodeCell(urlString: imageUrls[index])
    }

    func collectionNode(_ collectionNode: ASCollectionNode, didEndDisplayingItemWith node: ASCellNode) {
        control.currentPage = pagerNode.currentPageIndex
    }

}

extension ProductImagesPagerNode: Decoratable {

    typealias ViewModel = ProductImagesPagerNodeViewModel

    func decorate(model: ViewModel) {
        self.imageUrls = model.imageURLs
    }

}

final class ImageNodeCell: ASCellNode, ASNetworkImageNodeDelegate {

    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let imageNode = ASNetworkImageNode()

    init(urlString: String?) {
        super.init()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageNode.backgroundColor = .mainBackground
        addSubnode(imageNode)
        imageNode.contentMode = .scaleAspectFit
        imageNode.delegate = self
        imageNode.setURL(URL(string: urlString!), resetToDefault: true)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: imageNode)
    }

    func imageNodeDidStartFetchingData(_ imageNode: ASNetworkImageNode) {
        activityIndicator.startAnimating()
        imageNode.view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageNode.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageNode.view.centerYAnchor)
        ])
    }

    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        activityIndicator.stopAnimating()
    }

}
