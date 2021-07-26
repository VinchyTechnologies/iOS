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
  static let separatorHeight: CGFloat = 1.0 / UIScreen.main.scale
}

// MARK: - SeparatorFlowLayoutDelegate

public protocol SeparatorFlowLayoutDelegate: AnyObject {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: SeparatorFlowLayout,
    shouldShowSeparatorBelowItemAt indexPath: IndexPath)
    -> Bool

  func collectionViewLeftOffsetForSeparator(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: SeparatorFlowLayout)
    -> CGFloat
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

// MARK: - SeparatorReusableView

final class SeparatorReusableView: UICollectionReusableView, Reusable {

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

// MARK: - SeparatorFlowLayout

// More info: https://www.raizlabs.com/dev/2014/02/animating-items-in-a-uicollectionview/
public class SeparatorFlowLayout: UICollectionViewFlowLayout {

  // MARK: Lifecycle

  public override init() {
    super.init()
    minimumLineSpacing = Constants.separatorHeight
    register(SeparatorReusableView.self, forDecorationViewOfKind: SeparatorReusableView.reuseId)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public weak var delegate: SeparatorFlowLayoutDelegate?

  public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    true
  }

  public override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
    super.prepare(forCollectionViewUpdates: updateItems)

    for item in updateItems {
      switch item.updateAction {
      case .delete:
        if let indexPath = item.indexPathBeforeUpdate {
          indexPathsToDelete.append(indexPath)
        }

      case .insert:
        if let indexPath = item.indexPathAfterUpdate {
          indexPathsToInsert.append(indexPath)
        }

      default:
        break
      }
    }
  }

  public override func finalizeCollectionViewUpdates() {
    super.finalizeCollectionViewUpdates()

    indexPathsToDelete.removeAll()
    indexPathsToInsert.removeAll()
  }

  public override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
    indexPathsToDelete
  }

  public override func indexPathsToInsertForDecorationView(ofKind elementKind: String) -> [IndexPath] {
    indexPathsToInsert
  }

  public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let layoutAttributesArray = super.layoutAttributesForElements(in: rect) else { return nil }

    var decorationAttributes: [UICollectionViewLayoutAttributes] = []
    for layoutAttributes in layoutAttributesArray {

      let indexPath = layoutAttributes.indexPath
      if let separatorAttributes = layoutAttributesForDecorationView(ofKind: SeparatorReusableView.reuseId, at: indexPath) {
        if rect.intersects(separatorAttributes.frame) {
          decorationAttributes.append(separatorAttributes)
        }
      }
    }

    let allAttributes = layoutAttributesArray + decorationAttributes
    return allAttributes
  }

  public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let cellAttributes = layoutAttributesForItem(at: indexPath) else {
      return createAttributesForMyDecoration(at: indexPath)
    }
    return layoutAttributesForMyDecoratinoView(at: indexPath, for: cellAttributes.frame, state: .normal)
  }

  public override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let cellAttributes = initialLayoutAttributesForAppearingItem(at: indexPath) else {
      return createAttributesForMyDecoration(at: indexPath)
    }
    return layoutAttributesForMyDecoratinoView(at: indexPath, for: cellAttributes.frame, state: .initial)
  }

  public override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let cellAttributes = finalLayoutAttributesForDisappearingItem(at: indexPath) else {
      return createAttributesForMyDecoration(at: indexPath)
    }
    return layoutAttributesForMyDecoratinoView(at: indexPath, for: cellAttributes.frame, state: .final)
  }

  // MARK: Private

  private enum State {
    case initial
    case normal
    case final
  }

  private var indexPathsToInsert: [IndexPath] = []
  private var indexPathsToDelete: [IndexPath] = []

  private func createAttributesForMyDecoration(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
    UICollectionViewLayoutAttributes(forDecorationViewOfKind: SeparatorReusableView.reuseId, with: indexPath)
  }

  private func layoutAttributesForMyDecoratinoView(at indexPath: IndexPath, for cellFrame: CGRect, state: State) -> UICollectionViewLayoutAttributes? {

    guard let collectionView = collectionView else {
      return nil
    }

    if delegate?.collectionView(collectionView, layout: self, shouldShowSeparatorBelowItemAt: indexPath) == false {
      return nil
    }

    let rect = collectionView.bounds

    // Add separator for every row except the first // WHY?????
    guard indexPath.item > 0 else {
      return nil
    }

    let separatorAttributes = createAttributesForMyDecoration(at: indexPath)
    separatorAttributes.alpha = 1.0
    separatorAttributes.isHidden = false

    var leftOffset = Constants.separatorLeftOffset
    let firstCellInRow = cellFrame.origin.x < cellFrame.width
    if firstCellInRow {
      // horizontal line
      if let delegate = delegate {
        leftOffset = delegate.collectionViewLeftOffsetForSeparator(collectionView, layout: self)
      }

      separatorAttributes.frame = CGRect(x: rect.minX + leftOffset, y: cellFrame.origin.y - minimumLineSpacing, width: rect.width - leftOffset, height: minimumLineSpacing)
      // separatorAttributes.zIndex = 1000

    } else {
      // vertical line
      separatorAttributes.frame = CGRect(x: cellFrame.origin.x - minimumInteritemSpacing, y: cellFrame.origin.y, width: minimumInteritemSpacing, height: cellFrame.height)
//      separatorAttributes.zIndex = 1000
    }

    // Sync the decorator animation with the cell animation in order to avoid blinkining
    switch state {
    case .normal:
      separatorAttributes.alpha = 1

    default:
      separatorAttributes.alpha = 0.1
    }

    return separatorAttributes
  }
}
