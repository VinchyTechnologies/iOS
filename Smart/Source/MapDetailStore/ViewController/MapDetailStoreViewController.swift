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

final class MapDetailStoreViewController: UIViewController {
  
  // MARK: - Internal Properties
  
  var interactor: MapDetailStoreInteractorProtocol?
  
  // MARK: - Private Properties
  
  private(set) var loadingIndicator = ActivityIndicatorView()
  private var viewModel: MapDetailStoreViewModel? {
    didSet {
      collectionView.reloadData()
    }
  }
  
  private lazy var layout = UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
    
    guard let self = self else { return nil }
    
    guard let type = self.viewModel?.sections[sectionNumber] else {
      return nil
    }
    
    switch type {
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
      TextCollectionCell.self,
      WorkingHoursCollectionCell.self,
      AssortmentCollectionCell.self,
      VinchySimpleConiniousCaruselCollectionCell.self)
    return $0
  }(WineDetailCollectionView(frame: .zero, collectionViewLayout: layout))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .mainBackground
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "figure.walk")?.withTintColor(.accent, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(didTapBuildRoute(_:)))
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal),
      style: .plain,
      target: self,
      action: #selector(didTapClose(_:)))
    
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
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
    collectionView.layoutSubviews()
    print(collectionView.collectionViewLayout.collectionViewContentSize)
    
    sheetViewController?.setSizes(
      [
        .fixed(layout.collectionViewContentSize.height + 24 /* pull Bar height */ + (UIApplication.shared.asKeyWindow?.safeAreaInsets.bottom ?? 0)), .fullscreen])
  }
}

extension MapDetailStoreViewController: VinchySimpleConiniousCaruselCollectionCellDelegate {
  
  func didTapBottleCell(wineID: Int64) {
  }
  
  func didTapCompilationCell(wines: [ShortWine], title: String?) { }
}
