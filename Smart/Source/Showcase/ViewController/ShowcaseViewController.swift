//
//  ShowcaseViewController.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 07.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import CommonUI
import VinchyCore
import Display
import StringFormatting

enum ShowcaseMode {
  case normal(wines: [ShortWine])
  case advancedSearch(params: [(String, String)])
}

final class ShowcaseViewController: UIViewController, UICollectionViewDelegate, Loadable {
  
  private enum C {
    static let limit: Int = 40
    static let inset: CGFloat = 10
  }
  
  private(set) var loadingIndicator = ActivityIndicatorView()
  var interactor: ShowcaseInteractorProtocol?
  
  private var categoryItems: [CategoryItem] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  
  private var filtersHeaderView = ASFiltersHeaderView()
  
  private lazy var collectionView: UICollectionView = {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .clear
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    collectionView.register(WineCollectionViewCell.self)
    collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseId)
    collectionView.register(LoadingCollectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingCollectionFooter.reuseId)
    collectionView.delaysContentTouches = false
    collectionView.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
    
    return collectionView
  }()
  
  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.startLoadingAnimation()
    self.addLoader()
  }
  
  private var didAddShadow = false
  private var isAnimating = false
  private var currentSection: Int = 0 {
    willSet {
      filtersHeaderView.scrollTo(section: newValue)
    }
  }
  
  private var shouldLoadMore = true
  
  private let mode: ShowcaseMode
  
  init(navTitle: String?, mode: ShowcaseMode) {
    self.mode = mode
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor?.loadWines(mode: mode)
    
    navigationItem.largeTitleDisplayMode = .never

    view.backgroundColor = .mainBackground
    
    view.addSubview(collectionView)
    collectionView.fill()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }
  
  private func layout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.sectionHeadersPinToVisibleBounds = true
    layout.sectionInset = UIEdgeInsets(top: 0, left: C.inset, bottom: 0, right: C.inset)
    layout.minimumLineSpacing = C.inset
    layout.minimumInteritemSpacing = 0
    return layout
  }
  
  func stopLoading() {
    self.dispatchWorkItemHud.cancel()
    self.stopLoadingAnimation()
  }
  
  private func fetchCategoryItems() {
    let categoryTitles = categoryItems.compactMap({ $0.title })
    filtersHeaderView.decorate(model: .init(categoryTitles: categoryTitles, filterDelegate: self))
  }

  private func hideErrorView() {
    DispatchQueue.main.async {
      self.collectionView.backgroundView = nil
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
    -> CGSize
  {
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
    
    let itemWidth = Int((UIScreen.main.bounds.width - C.inset * CGFloat(rowCount + 1)) / CGFloat(rowCount))
    let itemHeight = Int(Double(itemWidth) * 1.5)
    return CGSize(width: itemWidth, height: itemHeight)
  }
}

extension ShowcaseViewController: ErrorViewDelegate {
  
  func didTapErrorButton(_ button: UIButton) {
    interactor?.loadMoreWines()
  }
}

extension ShowcaseViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    categoryItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    categoryItems[section].wines.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as? WineCollectionViewCell,
       let wine = categoryItems[safe: indexPath.section]?.wines[safe: indexPath.row] {
      cell.decorate(model: .init(imageURL: wine.mainImageUrl?.toURL, titleText: wine.title,
                                 subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode)))
      return cell
    }
    return .init()
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    switch mode {
    case .normal:
      break
    case .advancedSearch:
      if indexPath.section == categoryItems.count - 1 && indexPath.row == categoryItems[indexPath.section].wines.count - 2 {
          interactor?.loadMoreWines()
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      // swiftlint:disable:next force_cast
      let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseId, for: indexPath) as! HeaderReusableView
      let categoryItem = categoryItems[indexPath.section]
      reusableview.decorate(model: .init(title: categoryItem.title))
      return reusableview
      
    case UICollectionView.elementKindSectionFooter:
      // swiftlint:disable:next force_cast
      let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingCollectionFooter.reuseId, for: indexPath) as! LoadingCollectionFooter
      switch mode {
      case .normal:
        reusableview.loadingIndicator.isAnimating = false
      case .advancedSearch:
        reusableview.loadingIndicator.isAnimating = shouldLoadMore
      }
      return reusableview
      
    default:
      return .init()
    }
  }
  
  func updateMoreLoader(shouldLoadMore: Bool) {
    self.shouldLoadMore = shouldLoadMore
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .init(width: collectionView.frame.width, height: filtersHeaderView.isHidden ? 0 : 50)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return .init(width: collectionView.bounds.width, height: shouldLoadMore ? 50 : 0)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if scrollView.contentOffset.y > 0 {
      if !didAddShadow {
        UIView.animate(withDuration: 0.5) {
          self.filtersHeaderView.addSoftUIEffectForView()
          self.didAddShadow = true
        }
      }
    } else {
      if didAddShadow {
        UIView.animate(withDuration: 0.5) {
          self.filtersHeaderView.removeSoftUIEffectForView()
          self.didAddShadow = false
        }
      }
    }
    
    if isAnimating { return }
    
    if let section = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionFooter).min()?.section {
      isAnimating = false
      if section != currentSection {
        currentSection = section
      }
    }
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    isAnimating = false
    filtersHeaderView.isUserIntaractionEnabled(true)
  }
  
}

extension ShowcaseViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let wine = categoryItems[safe: indexPath.section]?.wines[safe: indexPath.row] else { return }
    navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wine.id), animated: true)
  }
}

extension ShowcaseViewController: FiltersHeaderViewDelegate {
  func didTapFilter(index: Int) {
    isAnimating = true
    filtersHeaderView.isUserIntaractionEnabled(currentSection != index)
    
    let indexPath = IndexPath(item: 0, section: index)
    
    if let attributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
      let topOfHeader = CGPoint(x: 0, y: attributes.frame.origin.y - collectionView.contentInset.top)
      collectionView.setContentOffset(topOfHeader, animated: true)
    }
  }
}

extension ShowcaseViewController: ShowcaseViewControllerProtocol {
  func update(category: [CategoryItem]) {
    self.categoryItems = category
  }
  func updateUI(errorViewModel: ErrorViewModel) {
    DispatchQueue.main.async {
      let errorView = ErrorView(frame: self.view.frame)
      errorView.decorate(model: errorViewModel)
      errorView.delegate = self
      self.collectionView.backgroundView = errorView
    }
  }
}
