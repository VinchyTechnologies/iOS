//
//  FiltersHeaderView.swift
//  ASUI
//
//  Created by Aleksei Smirnov on 28.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display

public protocol FiltersHeaderViewDelegate: AnyObject {
    func didTapFilter(index: Int)
}

struct ASFiltersHeaderViewModel: ViewModelProtocol {
    let categoryTitles: [String]
    let filterDelegate: FiltersHeaderViewDelegate?
}

final class ASFiltersHeaderView: ASDisplayNode {

    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var collectionNode = ASCollectionNode(collectionViewLayout: layout)

    private var categoryTitles: [String] = [] {
        didSet {
            DispatchQueue.main.async {

                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.hilightFirst()
                })
                self.collectionNode.reloadData()
                CATransaction.commit()
            }
        }
    }

    private weak var filterDelegate: FiltersHeaderViewDelegate?

    override init() {
        super.init()
        addSubnode(collectionNode)
        collectionNode.dataSource = self
        collectionNode.delegate = self
        collectionNode.showsHorizontalScrollIndicator = false
        collectionNode.backgroundColor = .mainBackground
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        ASInsetLayoutSpec(insets: .zero, child: collectionNode)
    }

    public func hilightFirst() {
        if let cell = collectionNode.nodeForItem(at: IndexPath(item: 0, section: 0)) as? ASTextCellNode {
            cell.textAttributes = ASTextNodeAttributes.common(size: 16, textColor: .accent)
        }
    }

    public func isUserIntaractionEnabled(_ flag: Bool) {
        isUserInteractionEnabled = flag
    }

    public func scrollTo(section: Int) {
        collectionNode.scrollToItem(at: IndexPath(item: section, section: 0), at: .centeredHorizontally, animated: true)
        collectionNode.visibleNodes.forEach { (cell) in
            if let cell = cell as? ASTextCellNode {
                if cell == self.collectionNode.nodeForItem(at: IndexPath(item: section, section: 0)) {
                    cell.textAttributes = ASTextNodeAttributes.common(size: 16, textColor: .dark)
                } else {
                    cell.textAttributes = ASTextNodeAttributes.common(size: 16, textColor: .secondaryLabel)
                }
            }
        }
    }

    func addSoftUIEffectForView(themeColor: UIColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)) {
        clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowColor = UIColor(red: 223/255, green: 228/255, blue: 238/255, alpha: 1.0).cgColor

        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.backgroundColor = themeColor.cgColor
        shadowLayer.shadowColor = UIColor.white.cgColor
        shadowLayer.shadowOffset = CGSize(width: -2.0, height: -2.0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 2
        self.layer.insertSublayer(shadowLayer, at: 0)
    }

    func removeSoftUIEffectForView() {
        self.clipsToBounds = true
    }
}

extension ASFiltersHeaderView: Decoratable {

    typealias ViewModel = ASFiltersHeaderViewModel

    func decorate(model: ViewModel) {
        self.categoryTitles = model.categoryTitles
        self.filterDelegate = model.filterDelegate
    }
}

extension ASFiltersHeaderView: ASCollectionDataSource {

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return categoryTitles.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let cell = ASTextCellNode()
        cell.text = categoryTitles[safe: indexPath.row]
        cell.textAttributes = ASTextNodeAttributes.common(size: 16, textColor: .secondaryLabel)
        return cell
    }
}

extension ASFiltersHeaderView: ASCollectionDelegate {

    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        collectionNode.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        collectionNode.visibleNodes.forEach { (cell) in
            if let cell = cell as? ASTextCellNode {
                if cell == collectionNode.nodeForItem(at: indexPath) {
                    cell.textAttributes = ASTextNodeAttributes.common(size: 16, textColor: .accent)
                } else {
                    cell.textAttributes = ASTextNodeAttributes.common(size: 16, textColor: .secondaryLabel)
                }
            }
        }
        
        filterDelegate?.didTapFilter(index: indexPath.row)
    }
}
