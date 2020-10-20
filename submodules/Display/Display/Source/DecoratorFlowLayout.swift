//
//  DecoratorFlowLayout.swift
//  Display
//
//  Created by Aleksei Smirnov on 13.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

public protocol DecoratorFlowLayoutDelegate: AnyObject, UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: DecoratorFlowLayout,
        shadowForCellAt indexPath: IndexPath,
        withFrame frame: CGRect)
        -> CALayer.Shadow?

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: DecoratorFlowLayout,
        cornerRadiusForCellAt indexPath: IndexPath,
        withFrame frame: CGRect)
        -> CGFloat?
}

public extension DecoratorFlowLayoutDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: DecoratorFlowLayout,
        shadowForCellAt indexPath: IndexPath,
        withFrame frame: CGRect)
        -> CALayer.Shadow? { return nil }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: DecoratorFlowLayout,
        cornerRadiusForCellAt indexPath: IndexPath,
        withFrame frame: CGRect)
        -> CGFloat? { return nil }
}

public enum LayoutAlignment {
    case left
}

protocol AlignmentProcessorProtocol: class {
    var supportedAlignment: LayoutAlignment { get }
    func process(attributes: [UICollectionViewLayoutAttributes],
                 for layout: UICollectionViewFlowLayout) -> [UICollectionViewLayoutAttributes]
}

final class LeftAlignmentProcessor: AlignmentProcessorProtocol {

    let supportedAlignment = LayoutAlignment.left

    func process(attributes: [UICollectionViewLayoutAttributes], for layout: UICollectionViewFlowLayout) -> [UICollectionViewLayoutAttributes] {
        guard layout.scrollDirection == .vertical,
            let collectionView = layout.collectionView else { return attributes }
        let sortedAttributes = attributes.sorted(by: { $0.indexPath < $1.indexPath })
        var itemMaxX: CGFloat?
        var rowMidY: CGFloat?
        return sortedAttributes.reduce(into: [UICollectionViewLayoutAttributes]()) { result, attributes in
            guard let copy = attributes.copy() as? UICollectionViewLayoutAttributes
                else { return }

            let section = attributes.indexPath.section
            if rowMidY != attributes.frame.midY {
                rowMidY = attributes.frame.midY
                itemMaxX = nil
            }

            let itemInset = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
                .collectionView?(collectionView, layout: layout, minimumInteritemSpacingForSectionAt: section)
                ?? layout.minimumInteritemSpacing

            let originX = itemMaxX.map({ $0 + itemInset })
                ?? collectionView.contentInset.left + ((collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
                    .collectionView?(collectionView, layout: layout, insetForSectionAt: section).left ?? .zero)

            let frame = CGRect(origin: CGPoint(x: originX, y: copy.frame.minY), size: copy.frame.size)
            copy.frame = frame
            result.append(copy)
            itemMaxX = frame.maxX
        }
    }
}

open class DecoratorLayoutAttributes: UICollectionViewLayoutAttributes {

    public var shadow: CALayer.Shadow?
    public var cornerRadius: CGFloat?

    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        let decorator = copy as? Self
        decorator?.shadow = shadow
        decorator?.cornerRadius = cornerRadius
        return copy
    }

    open override func isEqual(_ object: Any?) -> Bool {
        guard super.isEqual(object),
            let otherAttributes = object as? Self else { return false }
        return otherAttributes.shadow == shadow
            && otherAttributes.cornerRadius == cornerRadius
    }

}

public extension CALayer {

    struct Shadow: Equatable {

        public static let `default` = Self(color: UIColor.black.cgColor,
                                           opacity: 0.08,
                                           offset: CGSize(width: .zero, height: -2),
                                           radius: 8)

        public var color: CGColor?
        public var opacity: Float?
        public var offset: CGSize?
        public var radius: CGFloat?

        public init(color: CGColor? = nil,
                    opacity: Float? = nil,
                    offset: CGSize? = nil,
                    radius: CGFloat? = nil) {
            self.color = color
            self.opacity = opacity
            self.offset = offset
            self.radius = radius
        }
    }

    func apply(shadow: Shadow?, withPath path: CGPath? = nil) {
        shadowColor = shadow?.color
        shadowOpacity = shadow?.opacity ?? .zero
        shadowOffset = shadow?.offset ?? .zero
        shadowRadius = shadow?.radius ?? .zero
        shadowPath = path
    }
}

public extension CALayer {

    func apply(cornerRadius: CGFloat?) {
        self.cornerRadius = cornerRadius ?? .zero
        masksToBounds = self.cornerRadius > .zero
    }
}

public class DecoratorFlowLayout: UICollectionViewFlowLayout {

    public var alignment: LayoutAlignment?
    public var cellPaginationOffset: CGFloat?
    private var recentOffset: CGPoint = .zero
    public weak var delegate: DecoratorFlowLayoutDelegate?

    private var decoratorsCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private let alignmentProcessors: [AlignmentProcessorProtocol] = [
        LeftAlignmentProcessor()
    ]

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var attributes = super.layoutAttributesForElements(in: rect) else { return nil }

        let indexPaths = Set(attributes.map({ $0.indexPath }))
        let decorationAttributes = indexPaths.compactMap({ decoratorLayoutAttributes(at: $0) })
        attributes.append(contentsOf: alignedAttributes(from: decorationAttributes))

        return attributes
    }

    override public func invalidateLayout() {
        decoratorsCache.removeAll()
        super.invalidateLayout()
    }

    private func decoratorLayoutAttributes(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView, let delegate = delegate else { return nil }

        if let cachedAttributes = decoratorsCache[indexPath] { return cachedAttributes }

        guard collectionView.numberOfItems(inSection: indexPath.section) > .zero else { return nil }
        guard let itemAttribute = layoutAttributesForItem(at: indexPath) else { return nil }
        let frame = itemAttribute.frame

        let decoratorAttributes = DecoratorLayoutAttributes(forCellWith: indexPath)
        decoratorAttributes.frame = frame
        decoratorAttributes.shadow = delegate.collectionView(collectionView, layout: self, shadowForCellAt: indexPath, withFrame: frame)
        decoratorAttributes.cornerRadius = delegate.collectionView(collectionView, layout: self, cornerRadiusForCellAt: indexPath, withFrame: frame)

        decoratorsCache[indexPath] = decoratorAttributes
        return decoratorAttributes
    }

    private func alignedAttributes(from attributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes] {
        guard let alignment = alignment,
            let processor = alignmentProcessors.first(where: { $0.supportedAlignment == alignment })
            else { return attributes }
        return processor.process(attributes: attributes, for: self)
    }

    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView,
            let cellPaginationOffset = cellPaginationOffset else {
                return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }

        let cvBouns = CGRect(
            x: proposedContentOffset.x,
            y: proposedContentOffset.y,
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )

        guard let visibleAttributes = self.layoutAttributesForElements(in: cvBouns) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }

        var candidate: UICollectionViewLayoutAttributes?
        for attributes in visibleAttributes {
            if attributes.center.x < proposedContentOffset.x {
                continue
            }

            candidate = attributes
            break
        }

        if proposedContentOffset.x + collectionView.frame.width - collectionView.contentInset.left - cellPaginationOffset > collectionView.contentSize.width {
            candidate = visibleAttributes.last
        }

        if let candidate = candidate {
            recentOffset = CGPoint(x: candidate.frame.origin.x - cellPaginationOffset, y: proposedContentOffset.y)
            return recentOffset
        } else {
            return recentOffset
        }
    }

}
