//
//  ShowcaseViewController.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 07.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import Display
import DisplayMini
import EpoxyBars
import EpoxyCollectionView
import EpoxyCore
import StringFormatting
import UIKit
import VinchyCore
import VinchyUI

// MARK: - C

private enum C {
  static let limit: Int = 40
  static let horizontalInset: CGFloat = 16
  static let tabViewHeight: CGFloat = 56
}

// MARK: - ShowcaseViewController

final class ShowcaseViewController: UIViewController, Loadable {

  // MARK: Lifecycle

  public init(input: ShowcaseInput) {
    self.input = input
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  var interactor: ShowcaseInteractorProtocol?

  private(set) var loadingIndicator = ActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground
    navigationItem.largeTitleDisplayMode = .never
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    if isModal {
      navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "xmark", withConfiguration: imageConfig),
        style: .plain,
        target: self,
        action: #selector(didTapCloseBarButtonItem(_:)))
    }

    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    bottomBarInstaller.install()

    switch input.mode {

    case .advancedSearch, .remote:
      break

    case .questions:
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "xmark", withConfiguration: imageConfig),
        style: .plain,
        target: self,
        action: #selector(didTapCloseBarButtonItem(_:)))
    }

    interactor?.viewDidLoad()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    if UIApplication.shared.applicationState != .background {
      coordinator.animate(alongsideTransition: { _ in
        self.collectionViewSize = size
        self.collectionView.setSections(self.sections, animated: false)
      })
    }
  }

  // MARK: Private

  private let input: ShowcaseInput

  private var shouldCallScrollViewDidScroll = true
  private var isGoingScrollToTopViaTappingStatusBar = false

  private lazy var shareButton = UIButton(type: .system)

  private lazy var tabView: TabView = {
    $0.delegate = self
    $0.collectionView.didBeginAnimation = { [weak self] in
      self?.shouldCallScrollViewDidScroll = false
    }
    $0.collectionView.didEndAnimation = { [weak self] in
      self?.shouldCallScrollViewDidScroll = true
    }
    return $0
  }(TabView())

  private lazy var collectionView: CollectionView = {
    let collectionView = CollectionView(
      layout: layout,
      configuration: .init(
        usesBatchUpdatesForAllReloads: false,
        usesCellPrefetching: true,
        usesAccurateScrollToItem: true))
    collectionView.backgroundColor = .clear
    collectionView.delaysContentTouches = false
    collectionView.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
    collectionView.prefetchDelegate = self
    collectionView.scrollDelegate = self
    return collectionView
  }()

  private lazy var collectionViewSize: CGSize = view.frame.size

  private let layout: ShowcaseLayout = {
    let layout = ShowcaseLayout()
    layout.sectionHeadersPinToVisibleBounds = true
    layout.sectionInset = .init(top: 0, left: C.horizontalInset, bottom: 0, right: C.horizontalInset)
    layout.minimumInteritemSpacing = C.horizontalInset
    return layout
  }()

  private var viewModel: ShowcaseViewModel = .empty

  private lazy var bottomBarInstaller = BottomBarInstaller(
    viewController: self,
    bars: bars)

  @SectionModelBuilder
  private var sections: [SectionModel] {
    switch viewModel.state {
    case .error(let sections):
      sections.compactMap { section in
        switch section {
        case .common(let content):
          let height = collectionViewSize.height
            - (navigationController?.navigationBar.frame.height ?? 0)
            - (UIApplication.shared.asKeyWindow?.layoutMargins.top ?? 0)
            - (UIApplication.shared.asKeyWindow?.layoutMargins.bottom ?? 0)
          return SectionModel(dataID: UUID()) {
            EpoxyErrorView.itemModel(
              dataID: UUID(),
              content: content,
              style: .init())
              .setBehaviors { [weak self] context in
                context.view.delegate = self
              }
          }
          .flowLayoutItemSize(.init(width: collectionViewSize.width - C.horizontalInset * 2, height: height))
          .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 8, right: 0))
          .flowLayoutHeaderReferenceSize(.zero)
        }
      }

    case .normal(let headerContent, let sections):
      sections.compactMap { section in
        switch section {
        case .content(let dataID, let items):
          return SectionModel(dataID: dataID) {
            items.compactMap { item in
              switch item {
              case .title(let itemID, let content):
                let style: Label.Style = .style(with: TextStyle.lagerTitle)
                let width: CGFloat = collectionViewSize.width - 2 * C.horizontalInset
                let height: CGFloat = Label.height(for: content, width: width, style: style)
                return Label.itemModel(
                  dataID: itemID,
                  content: content,
                  style: style)
                  .flowLayoutItemSize(.init(width: width, height: height))

              case .bottle(let itemID, let content):
                let rowCount: Int = {
                  if UIDevice.current.userInterfaceIdiom == .pad {
                    if Orientation.isLandscape {
                      return 4
                    } else {
                      return 3
                    }
                  } else {
                    return 2
                  }
                }()

                let itemWidth = Int((UIScreen.main.bounds.width - C.horizontalInset * CGFloat(rowCount + 1)) / CGFloat(rowCount))
                let itemHeight = 250
                var kind: WineBottleView.Style.Kind = .normal
                switch input.mode {
                case .advancedSearch, .remote:
                  break

                case .questions:
                  kind = .price
                }
                return WineBottleView.itemModel(
                  dataID: itemID,
                  content: content,
                  style: .init(kind: kind))
                  .didSelect({ [weak self] _ in
                    self?.interactor?.didSelectWine(wineID: content.wineID)
                  })
                  .setBehaviors({ [weak self] context in
                    guard let self = self else { return }
                    context.view.delegate = self
                  })
                  .flowLayoutItemSize(.init(width: itemWidth, height: itemHeight))

              case .loading:
                return LoadingView.itemModel(dataID: UUID())
                  .willDisplay { [weak self] _ in
                    self?.interactor?.willDisplayLoadingView()
                  }
                  .flowLayoutItemSize(.init(width: collectionViewSize.width, height: LoadingView.height))
              }
            }
          }
          .supplementaryItems(ofKind: UICollectionView.elementKindSectionHeader, [
            SupplementaryItemModel(dataID: UUID(), params: UUID(), content: headerContent, makeView: { [weak self] _ in
              guard let self = self else { return UIView() }
              return self.tabView
            }, setContent: { [weak self] _, _ in
              self?.tabView.configure(with: headerContent)
            }),
          ])
          .flowLayoutHeaderReferenceSize(.init(width: collectionViewSize.width, height: C.tabViewHeight))
        }
      }
    }
  }

  @BarModelBuilder
  private var bars: [BarModeling] {
    if let bottomPriceBarViewModel = viewModel.bottomBarViewModel {
      [
        BottomPriceBarView.barModel(
          dataID: nil,
          content: bottomPriceBarViewModel,
          behaviors: .init(didSelect: { [weak self] _ in
            self?.interactor?.didTapRepeatQuestionsButton()
          }),
          style: .init(kind: .buttonOnly)),
      ]
    } else {
      []
    }
  }

  private func shouldScroll(isDecelerating: Bool, isDragging: Bool) -> Bool {
    if isGoingScrollToTopViaTappingStatusBar {
      return true
    } else {
      return (isDecelerating || isDragging) && shouldCallScrollViewDidScroll
    }
  }
  private func updateShadowSupplementaryHeaderView(offset: CGFloat) {
    let value: CGFloat = offset
    let alpha = min(1, max(0, value / 10))
    tabView.layer.shadowOpacity = Float(alpha / 2.0)
  }

  @objc
  private func didTapCloseBarButtonItem(_: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  @objc
  private func didTapShare(_ button: UIButton) {
    interactor?.didTapShare(sourceView: button)
  }
}

// MARK: ShowcaseViewControllerProtocol

extension ShowcaseViewController: ShowcaseViewControllerProtocol {
  func updateUI(viewModel: ShowcaseViewModel) {
    self.viewModel = viewModel
    navigationItem.title = viewModel.navigationTitle
    if viewModel.isSharable {
      let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)
      shareButton.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig), for: .normal)
      shareButton.contentEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
      shareButton.tintColor = .dark
      shareButton.addTarget(self, action: #selector(didTapShare(_:)), for: .touchUpInside)

      let shareBarButtonItem = UIBarButtonItem(customView: shareButton)
      navigationItem.rightBarButtonItems = [shareBarButtonItem]
    }
    switch viewModel.state {
    case .normal:
      collectionView.isScrollEnabled = true

    case .error:
      collectionView.isScrollEnabled = false
    }
    collectionView.setSections(sections, animated: true)
    bottomBarInstaller.setBars(bars, animated: true)
  }
}

// MARK: EpoxyErrorViewDelegate

extension ShowcaseViewController: EpoxyErrorViewDelegate {
  func didTapErrorButton(_: UIButton) {
    interactor?.viewDidLoad() // TODO: - not viewdidload
  }
}

// MARK: CollectionViewPrefetchingDelegate

extension ShowcaseViewController: CollectionViewPrefetchingDelegate {

  func collectionView(_ collectionView: CollectionView, prefetch items: [AnyItemModel]) {
    for item in items {
      if let content = (item.model as? ItemModel<WineBottleView>)?.erasedContent as? WineBottleView.Content {
        ImageLoader.shared.prefetch(url: content.imageURL)
      }
    }
  }

  func collectionView(_ collectionView: CollectionView, cancelPrefetchingOf items: [AnyItemModel]) {
    for item in items {
      if
        let content = (item.model as? ItemModel<WineBottleView>)?.erasedContent as? WineBottleView.Content,
        let url = content.imageURL
      {
        ImageLoader.shared.cancelPrefetch([url])
      }
    }
  }
}

// MARK: TabViewDelegate

extension ShowcaseViewController: TabViewDelegate {
  func tabView(_ view: TabView, didSelect item: TabItemViewModel, atIndex index: Int) {
    let itemPath = ItemPath(
      itemDataID: index,
      section: .dataID(ShowcaseViewModel.DataID.content))

    guard let indexPath = collectionView.indexPathForItem(at: itemPath) else {
      return
    }

    guard let layout = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) else {
      return
    }

    let offset = CGPoint(x: 0, y: layout.frame.minY - C.tabViewHeight)
    collectionView.setContentOffset(offset, animated: true)
  }
}

// MARK: UIScrollViewDelegate

extension ShowcaseViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView === collectionView {
      if shouldScroll(isDecelerating: scrollView.isDecelerating, isDragging: scrollView.isDragging) {
        let attributes = layout.layoutAttributesForElements(in: CGRect(
          x: collectionView.frame.origin.x,
          y: max(0, scrollView.contentOffset.y + C.tabViewHeight),
          width: collectionView.frame.width,
          height: collectionView.frame.height)) ?? []

        let indexPathes = attributes
          .filter({ $0.representedElementCategory == .cell })
          .map({ $0.indexPath })

        let indexes: [Int] = indexPathes.compactMap { indexPath in
          switch (collectionView.item(at: indexPath)?.dataID as? ItemPath)?.section {
          case .dataID(let str):
            if let str = str as? String, str.prefix(3) == "sec" {
              let string = str.dropFirst(3)
              return Int(string)
            }
            return nil

          case .lastWithItemDataID, .none:
            return nil
          }
        }
        if let index = indexes.min() {
          tabView.selectItem(atIndex: index, animated: true)
        }
      }
      updateShadowSupplementaryHeaderView(offset: scrollView.contentOffset.y)
    }
  }

  func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    isGoingScrollToTopViaTappingStatusBar = true
    return true
  }

  func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    isGoingScrollToTopViaTappingStatusBar = false
  }
}

// MARK: WineBottleViewDelegate

extension ShowcaseViewController: WineBottleViewDelegate {
  func didTapShareContextMenu(wineID: Int64, sourceView: UIView) {

  }

  func didTapWriteNoteContextMenu(wineID: Int64) {

  }

  func didTapPriceButton(_ button: UIButton, wineID: Int64) {
    interactor?.didTapPriceButton(wineID: wineID)
  }
}
