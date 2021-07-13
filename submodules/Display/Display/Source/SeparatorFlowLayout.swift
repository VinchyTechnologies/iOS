//
//  SeparatorFlowLayout.swift
//  Display
//
//  Created by Алексей Смирнов on 13.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - Constants

private enum Constants {
  static let separatorViewKind = "separatorViewKind"
  static let separatorLeftOffset: CGFloat = 16
  static let separatorHeight: CGFloat = 0.5
}

// MARK: - SeparatorFlowLayoutDelegate

public protocol SeparatorFlowLayoutDelegate: AnyObject {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: SeparatorFlowLayout,
    shouldShowSeparatorBelowItemAt indexPath: IndexPath) -> Bool

  func collectionViewLeftOffsetForSeparator(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: SeparatorFlowLayout) -> CGFloat
}

extension SeparatorFlowLayoutDelegate {
  public func collectionViewLeftOffsetForSeparator(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: SeparatorFlowLayout)
    -> CGFloat
  {
    Constants.separatorLeftOffset
  }
}

// MARK: - SeparatorFlowLayout

public class SeparatorFlowLayout: UICollectionViewFlowLayout {

  // MARK: Lifecycle

  public override init() {
    super.init()
    register(SeparatorReusableView.self, forDecorationViewOfKind: Constants.separatorViewKind)
    minimumLineSpacing = Constants.separatorHeight
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public weak var delegate: SeparatorFlowLayoutDelegate?

  override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard var attributes = super.layoutAttributesForElements(in: rect) else { return nil }

    let decorationAttributes = attributes.compactMap { separatorLayoutAttributes(at: $0.indexPath, with: $0.frame) }
    attributes.append(contentsOf: decorationAttributes)

    return attributes
  }

  public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    separatorLayoutAttributes(at: indexPath)
  }

  // MARK: Private

  private func separatorLayoutAttributes(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard
      let collectionView = collectionView,
      delegate?.collectionView(
        collectionView,
        layout: self,
        shouldShowSeparatorBelowItemAt: indexPath) == true else
    {
      return nil
    }

    let separatorAttribute = UICollectionViewLayoutAttributes(
      forDecorationViewOfKind: Constants.separatorViewKind,
      with: indexPath)
    return separatorAttribute
  }

  private func separatorLayoutAttributes(at indexPath: IndexPath, with frame: CGRect) -> UICollectionViewLayoutAttributes? {
    let separatorAttribute = separatorLayoutAttributes(at: indexPath)
    let separatorHeight = minimumLineSpacing
    var leftOffset = Constants.separatorLeftOffset

    if let collectionView = collectionView, let delegate = delegate {
      leftOffset = delegate.collectionViewLeftOffsetForSeparator(collectionView, layout: self)
    }

    separatorAttribute?.frame = CGRect(
      x: frame.minX + leftOffset,
      y: frame.maxY - separatorHeight,
      width: frame.width - leftOffset,
      height: separatorHeight)
    return separatorAttribute
  }
}

// MARK: - SeparatorReusableView

final class SeparatorReusableView: UICollectionReusableView {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = Constants.separatorColor
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    frame = layoutAttributes.frame
  }

  // MARK: Private

  private enum Constants {
    static let separatorColor = UIColor.separator
  }

}
