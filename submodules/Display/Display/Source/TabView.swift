//
//  TabView.swift
//  Display
//
//  Created by Алексей Смирнов on 22.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - LocalConstants

fileprivate enum LocalConstants {
  static let collectionItemInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  static let collectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 16)
  static let collectionSelectionColor = UIColor.accent
  static let collectionSelectionRadius: CGFloat = 20
}

// MARK: - TabViewModel

public struct TabViewModel: Equatable {

  fileprivate let items: [TabItemViewModel]
  fileprivate let initiallySelectedIndex: Int

  public init(items: [TabItemViewModel], initiallySelectedIndex: Int) {
    self.items = items
    self.initiallySelectedIndex = initiallySelectedIndex
  }
}

// MARK: - TabViewDelegate

public protocol TabViewDelegate: AnyObject {
  func tabView(_ view: TabView, didSelect item: TabItemViewModel, atIndex index: Int)
}

// MARK: - TabView

public final class TabView: UIView {

  // MARK: Lifecycle

  // MARK: - Initializers

  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  // MARK: Public

  // MARK: - Public Properties

  public typealias ViewModel = TabViewModel

  public weak var delegate: TabViewDelegate?

  public var selectedIndex: Int? {
    guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return nil }
    return indexPath.section
  }

  // MARK: - Public Methods

  public func configure(with viewModel: ViewModel) {
    if self.viewModel != viewModel {
      self.viewModel = viewModel
      collectionView.reloadData()
      collectionView.layoutIfNeeded()
      underlyingCollectionView.reloadData()
      guard !viewModel.items.isEmpty else { return }
      selectItem(atIndex: viewModel.initiallySelectedIndex, animated: false)
    }
  }

  public func selectItem(atIndex index: Int, animated: Bool) {
    guard
      viewModel?.items.indices.contains(index) ?? false,
      currentSelectedItemIndex != index
    else {
      return
    }

    collectionView.selectItem(
      at: IndexPath(item: 0, section: index),
      animated: animated,
      scrollPosition: .centeredHorizontally)
  }

  public func setShadowAlpha(_ alpha: Float) {
    layer.shadowOpacity = alpha / 2.0
  }

  // MARK: Private

  // MARK: - Private Properties

  private typealias TabCell = TabItemCollectionCell

  private lazy var layout: DonerFlowLayout = {
    $0.scrollDirection = .horizontal
    $0.delegate = self
    return $0
  }(DonerFlowLayout())

  private lazy var collectionView: CollectionViewWithSelectionBackground = {
    $0.showsHorizontalScrollIndicator = false
    $0.backgroundColor = .accent
    $0.delegate = self
    $0.dataSource = self
    $0.contentInset = LocalConstants.collectionInsets
    $0.allowsMultipleSelection = false
    $0.decelerationRate = .fast
    $0.register(TabCell.self, forCellWithReuseIdentifier: TabCell.description())
    $0.selectionBackgroundColor = LocalConstants.collectionSelectionColor
    $0.selectionBackgroundRadius = LocalConstants.collectionSelectionRadius
    return $0
  }(CollectionViewWithSelectionBackground(frame: .zero, collectionViewLayout: layout))

  private lazy var underlyingCollectionView: UICollectionView = {
    $0.showsHorizontalScrollIndicator = false
    $0.backgroundColor = .mainBackground
    $0.delegate = self
    $0.dataSource = self
    $0.contentInset = LocalConstants.collectionInsets
    $0.allowsMultipleSelection = false
    $0.decelerationRate = .fast
    $0.register(TabCell.self, forCellWithReuseIdentifier: TabCell.description())
    return $0
  }(UICollectionView(frame: .zero, collectionViewLayout: layout))

  private var viewModel: ViewModel?

  private var currentSelectedItemIndex: Int? {
    collectionView.indexPathsForSelectedItems?.first?.section
  }

  // MARK: - Private Methods

  private func commonInit() {

    layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
    layer.shadowOpacity = 0.0
    layer.shadowOffset = CGSize(width: 0, height: 4)

    addSubview(underlyingCollectionView)
    underlyingCollectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      underlyingCollectionView.topAnchor.constraint(equalTo: topAnchor),
      underlyingCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      underlyingCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      underlyingCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])

    addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
}

// MARK: UICollectionViewDataSource

extension TabView: UICollectionViewDataSource {

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel?.items.count ?? 0
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    1
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let viewModel = self.viewModel?.items[indexPath.section],
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TabCell.description(),
        for: indexPath) as? TabCell
    else {
      return .init()
    }
    cell.state = collectionView === self.collectionView ? .normal : .selected
    cell.configure(with: viewModel)

    return cell
  }
}

// MARK: DonerFlowLayoutDelegate

extension TabView: DonerFlowLayoutDelegate {

  public func collectionView(
    _ collectionView: UICollectionView,
    frameForBackgroundViewAtSection section: Int)
    -> CGRect?
  {

    guard let viewModel = self.viewModel?.items[section] else {
      return .zero
    }

    let width = TabItemCollectionCell.width(viewModel: viewModel) + LocalConstants.collectionItemInsets.left + LocalConstants.collectionItemInsets.right

    let size = CGSize(
      width: width,
      height: collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom)
    return .init(origin: .zero, size: size)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cornerRadiusForCellAt indexPath: IndexPath)
    -> CGFloat?
  {
    LocalConstants.collectionSelectionRadius
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension TabView: UICollectionViewDelegateFlowLayout {

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
    -> CGSize
  {

    guard let viewModel = self.viewModel?.items[indexPath.section] else {
      return .zero
    }

    let width = TabItemCollectionCell.width(viewModel: viewModel) + LocalConstants.collectionItemInsets.left + LocalConstants.collectionItemInsets.right

    return CGSize(
      width: width,
      height: collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom)
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel?.items[safe: indexPath.section].map {
      delegate?.tabView(self, didSelect: $0, atIndex: indexPath.section)
      collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int)
    -> UIEdgeInsets
  {
    .init(top: 0, left: 8, bottom: 0, right: 0)
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == collectionView {
      var offset = underlyingCollectionView.contentOffset
      offset.x = collectionView.contentOffset.x
      underlyingCollectionView.setContentOffset(offset, animated: false)
    }
  }
}

// MARK: - TabItemViewModel

public struct TabItemViewModel: Equatable {

  fileprivate let titleText: String?

  public init(titleText: String?) {
    self.titleText = titleText
  }
}

// MARK: - TabItemCollectionCell

public final class TabItemCollectionCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  public override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])

    layer.cornerRadius = 20
    clipsToBounds = true
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Public

  public enum State {

    case normal, selected

    // MARK: Fileprivate

    fileprivate var textColor: UIColor {
      switch self {
      case .normal:
        return .white

      case .selected:
        return .blueGray
      }
    }

    fileprivate var backgroundColor: UIColor {
      switch self {
      case .normal:
        return .accent

      case .selected:
        return .option // ok
      }
    }
  }

  public var state: State = .normal {
    didSet {
      titleLabel.textColor = state.textColor
      backgroundColor = state.backgroundColor
    }
  }

  public static func width(viewModel: TabItemViewModel) -> CGFloat {
    guard let titleText = viewModel.titleText else {
      return .zero
    }
    return titleText.size(for: LocalConstants.titleFont).width
  }

  public func configure(with viewModel: TabItemViewModel) {
    titleLabel.text = viewModel.titleText
  }

  // MARK: Fileprivate

  fileprivate enum LocalConstants {
    static let titleFont = Font.bold(16)
    static let titleTextColor = UIColor.dark
  }

  // MARK: Private

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = LocalConstants.titleFont
    label.textAlignment = .center
    return label
  }()
}

// MARK: - CollectionViewWithSelectionBackground

public final class CollectionViewWithSelectionBackground: UICollectionView {

  // MARK: Public

  public var selectionBackgroundColor: UIColor? {
    didSet {
      selectionBackgroundView.backgroundColor = selectionBackgroundColor
    }
  }

  public var selectionBackgroundRadius: CGFloat = .zero {
    didSet {
      selectionBackgroundView.layer.cornerRadius = selectionBackgroundRadius
    }
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    sendSubviewToBack(selectionBackgroundView)
    layer.mask = selectionBackgroundView.layer
  }

  public override func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
    super.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    guard let indexPath = indexPath else { return }
    moveSelectionBackgroundViewToItem(at: indexPath, animated: animated)
  }

  // MARK: Private

  private var selectedIndexPath = IndexPath(row: 0, section: 0)

  private lazy var selectionBackgroundView: UIView = {
    let view = UIView(frame: .zero)
    insertSubview(view, at: .zero)
    return view
  }()

  private func moveSelectionBackgroundViewToItem(at indexPath: IndexPath, animated: Bool) {

    guard let attributes = layoutAttributesForItem(at: indexPath) else {
      return
    }

    let cellFrame = attributes.frame
    let frame = CGRect(
      x: cellFrame.origin.x,
      y: cellFrame.origin.y,
      width: cellFrame.size.width,
      height: cellFrame.size.height)
    UIView.animate(
      withDuration: 0.5,
      delay: 0.0,
      usingSpringWithDamping: CGFloat(0.9),
      initialSpringVelocity: CGFloat(2),
      options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction, .allowAnimatedContent],
      animations: {
        self.selectionBackgroundView.frame = frame
        self.selectedIndexPath = indexPath
      }, completion: nil)
  }
}

// MARK: - DonerFlowLayoutDelegate

public protocol DonerFlowLayoutDelegate: AnyObject {

  func collectionView(
    _ collectionView: UICollectionView,
    frameForBackgroundViewAtSection section: Int) -> CGRect?

  func collectionView(
    _ collectionView: UICollectionView,
    cornerRadiusBackgroundViewAtSection section: Int) -> CGFloat?

  func collectionView(
    _ collectionView: UICollectionView,
    cornerRadiusForCellAt indexPath: IndexPath) -> CGFloat?
}

extension DonerFlowLayoutDelegate {

  public func collectionView(
    _ collectionView: UICollectionView,
    frameForBackgroundViewAtSection section: Int)
    -> CGRect?
  {
    nil
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cornerRadiusBackgroundViewAtSection section: Int)
    -> CGFloat?
  {
    nil
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cornerRadiusForCellAt indexPath: IndexPath)
    -> CGFloat?
  {
    nil
  }
}

// MARK: - DonerFlowLayout

public final class DonerFlowLayout: UICollectionViewFlowLayout {

  // MARK: Lifecycle

  public override init() {
    super.init()
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  // MARK: Public

  public override class var layoutAttributesClass: AnyClass {
    DonerLayoutAttributes.classForCoder()
  }

  public weak var delegate: DonerFlowLayoutDelegate?

  public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    true
  }

  public override func layoutAttributesForSupplementaryView(
    ofKind elementKind: String,
    at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes?
  {
    switch elementKind {
    case supplementaryKind.rawValue:
      return supplementaryAttributes[indexPath]

    default:
      return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
  }

  override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    guard
      let collectionView = collectionView,
      var attributes = super.layoutAttributesForElements(in: rect)
    else {
      return nil
    }

    Array(.zero ..< collectionView.numberOfSections).forEach({
      guard let supplementaryFrame = frameOfSupplementaryView(in: $0) else { return }
      let indexPath = IndexPath(row: .zero, section: $0)
      let supplementaryAttribute = DonerLayoutAttributes(
        forSupplementaryViewOfKind: supplementaryKind.rawValue,
        with: indexPath)
      supplementaryAttribute.frame = supplementaryFrame
      supplementaryAttribute.cornerRadius = delegate?.collectionView(collectionView, cornerRadiusBackgroundViewAtSection: $0)
      attributes.append(supplementaryAttribute)
      supplementaryAttributes[indexPath] = supplementaryAttribute
    })

    return attributes.map({ convertLayoutAttributesToDLayoutAttributes($0) })
  }

  // MARK: Private

  private let supplementaryKind: UICollectionView.SupplementaryKind = .background
  private var supplementaryAttributes = [IndexPath: UICollectionViewLayoutAttributes]()

  private func frameOfSupplementaryView(in section: Int) -> CGRect? {

    guard
      let collectionView = collectionView,
      let delegate = delegate,
      let sectionOrigin = originOfSection(section),
      let supplementaryViewFrame = delegate.collectionView(
        collectionView,
        frameForBackgroundViewAtSection: section)
    else {
      return nil
    }

    let resultOrigin = CGPoint(
      x: sectionOrigin.x + supplementaryViewFrame.origin.x,
      y: sectionOrigin.y + supplementaryViewFrame.origin.y)

    return CGRect(origin: resultOrigin, size: supplementaryViewFrame.size)
  }

  private func originOfSection(_ section: Int) -> CGPoint? {
    guard
      let collectionView = collectionView,
      collectionView.numberOfItems(inSection: section) > .zero
    else {
      return nil
    }

    let indexPath = IndexPath(row: .zero, section: section)
    return collectionView.layoutAttributesForItem(at: indexPath)?.frame.origin
  }

  private func convertLayoutAttributesToDLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

    guard
      let collectionView = collectionView,
      let delegate = delegate,
      let dAttributes = attributes as? DonerLayoutAttributes,
      attributes.representedElementCategory == .cell
    else {
      return attributes
    }

    let indexPath = dAttributes.indexPath
    dAttributes.cornerRadius = delegate.collectionView(
      collectionView,
      cornerRadiusForCellAt: indexPath)
    return dAttributes
  }
}

// MARK: - DonerLayoutAttributes

public final class DonerLayoutAttributes: UICollectionViewLayoutAttributes {

  // MARK: - Public Properties

  public var cornerRadius: CGFloat?

  // MARK: - Public Methods

  public override func copy(with zone: NSZone? = nil) -> Any {
    let copy = super.copy(with: zone)
    let decorator = copy as? Self
    decorator?.cornerRadius = cornerRadius
    return copy
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard
      super.isEqual(object),
      let otherAttributes = object as? Self
    else {
      return false
    }

    return otherAttributes.cornerRadius == cornerRadius
  }
}

extension UICollectionView {

  public enum SupplementaryKind: String {

    case header
    case footer
    case background

    // MARK: Lifecycle

    public init?(rawValue: String) {
      switch rawValue {
      case UICollectionView.elementKindSectionHeader:
        self = .header

      case UICollectionView.elementKindSectionFooter:
        self = .footer

      case SupplementaryKind.background.rawValue:
        self = .background

      default:
        return nil
      }
    }

    // MARK: Public

    public var rawValue: String {
      switch self {
      case .header:
        return UICollectionView.elementKindSectionHeader

      case .footer:
        return UICollectionView.elementKindSectionFooter

      case .background:
        return "UICollectionView.elementKindSectionBackground"
      }
    }
  }
}
