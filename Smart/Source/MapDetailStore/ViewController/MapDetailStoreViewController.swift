//
//  MapDetailStoreViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import CommonUI
import FittedSheets
import VinchyCore
import UIKit

protocol MapDetailStoreViewControllerDelegate: AnyObject {
  func didTapRouteButton(_ button: UIButton)
  func didTapAssortmentButton(_ button: UIButton)
}

final class MapDetailStoreViewController: UIViewController {
  
  // MARK: - Internal Properties
  weak var delegate: MapDetailStoreViewControllerDelegate?
  var interactor: MapDetailStoreInteractorProtocol?
  
  // MARK: - Private Properties
  
  private(set) var loadingIndicator = ActivityIndicatorView()
  private var viewModel: MapDetailStoreViewModel? {
    didSet {
      collectionView.reloadData()
      collectionView.performBatchUpdates({
        let sheetSize = SheetSize.fixed(self.layout.collectionViewContentSize.height + 48 + 24 /* pull Bar height */ + (UIApplication.shared.asKeyWindow?.safeAreaInsets.bottom ?? 0))
      self.sheetViewController?.sizes = [sheetSize]
        self.sheetViewController?.resize(to: [sheetSize][0], duration: 0.5)
      }, completion: nil) // This blocks layoutIfNeeded animation
    }
  }
  
  private lazy var layout = UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
    
    guard let self = self else { return nil }
    
    guard let type = self.viewModel?.sections[sectionNumber] else {
      return nil
    }
    
    switch type {
    case .navigationBar:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 15, bottom: 0, trailing: 15)
      return section
      
    case .title, .address:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)))
      item.edgeSpacing = .init(leading: .none, top: .fixed(5), trailing: .none, bottom: .fixed(10))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
      return section
      
    case .workingHours:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 5, leading: 15, bottom: 0, trailing: 15)
      return section
      
    case .assortment:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)))
      item.edgeSpacing = .init(leading: .none, top: .fixed(20), trailing: .none, bottom: .none)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(54)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 5, leading: 15, bottom: 25, trailing: 15)
      return section
      
    case .recommendedWines:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 0, bottom: 10, trailing: 0)
      return section
    }
  }
  
  private lazy var collectionView: WineDetailCollectionView = {
    $0.backgroundColor = .mainBackground
    $0.dataSource = self
    $0.register(
      MapNavigationBarCollectionCell.self,
      TextCollectionCell.self,
      WorkingHoursCollectionCell.self,
      AssortmentCollectionCell.self,
      VinchySimpleConiniousCaruselCollectionCell.self)
    return $0
  }(WineDetailCollectionView(frame: .zero, collectionViewLayout: layout))
  
  private lazy var navigationBar: MapNavigationBar = {
    $0.delegate = self
    return $0
  }(MapNavigationBar())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .mainBackground
    
    view.addSubview(navigationBar)
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
      navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      navigationBar.heightAnchor.constraint(equalToConstant: 48),
    ])
    
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    sheetViewController?.handleScrollView(collectionView)
    
    interactor?.viewDidLoad()
  }
  
  @objc
  private func didTapBuildRoute(_ barButtonItem: UIBarButtonItem) {
    
  }
  
  @objc
  private func didTapClose(_ barButtonItem: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
}

extension MapDetailStoreViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel?.sections.count ?? 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    switch viewModel?.sections[safe: section] {
    case .navigationBar(let model):
      return model.count
    
    case .title(let model):
      return model.count
      
    case .address(let model):
      return model.count
      
    case .workingHours(let model):
      return model.count
      
    case .assortment(let model):
      return model.count
      
    case .recommendedWines(let model):
      return model.count
      
    case .none:
      return 0
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    switch viewModel?.sections[safe: indexPath.section] {
    case .navigationBar:
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapNavigationBarCollectionCell.reuseId, for: indexPath) as! MapNavigationBarCollectionCell
      return cell
      
    case .title(let model), .address(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
      cell.decorate(model: model[indexPath.row])
      return cell
      
    case .workingHours(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkingHoursCollectionCell.reuseId, for: indexPath) as! WorkingHoursCollectionCell
      cell.decorate(model: model[indexPath.row])
      return cell
      
    case .assortment(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssortmentCollectionCell.reuseId, for: indexPath) as! AssortmentCollectionCell
      cell.decorate(model: model[indexPath.row])
      cell.delegate = self
      return cell
      
    case .recommendedWines(let model):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: VinchySimpleConiniousCaruselCollectionCell.reuseId,
        for: indexPath) as! VinchySimpleConiniousCaruselCollectionCell// swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      cell.delegate = self
      return cell
      
    case .none:
      return .init()
    }
  }
}

// MARK: - MapDetailStoreViewControllerProtocol

extension MapDetailStoreViewController: MapDetailStoreViewControllerProtocol {
  func updateUI(viewModel: MapDetailStoreViewModel) {
    self.viewModel = viewModel
  }
}

extension MapDetailStoreViewController: VinchySimpleConiniousCaruselCollectionCellDelegate {
  
  func didTapBottleCell(wineID: Int64) {
    interactor?.didTapRecommendedWine(wineID: wineID)
  }
  
  func didTapCompilationCell(wines: [ShortWine], title: String?) { }
}

extension MapDetailStoreViewController: MapNavigationBarDelegate {
  
  func didTapLeadingButton(_ button: UIButton) {
    sheetViewController?.attemptDismiss(animated: true)
    self.delegate?.didTapRouteButton(button)
  }
  
  func didTapTrailingButton(_ button: UIButton) {
    sheetViewController?.attemptDismiss(animated: true)
  }
}

extension MapDetailStoreViewController: AssortmentCollectionCellDelegate {
  func didTapSeeAssortmentButton(_ button: UIButton) {
    delegate?.didTapAssortmentButton(button)
  }
}
