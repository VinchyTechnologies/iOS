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
    case .title:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 5, leading: 15, bottom: 0, trailing: 15)
      return section
    }
  }
  
  private lazy var collectionView: WineDetailCollectionView = {
    $0.backgroundColor = .mainBackground
    $0.dataSource = self
    $0.register(
      TextCollectionCell.self)
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
    collectionView.fill()
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
    case .title(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
      cell.decorate(model: model[indexPath.row])
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
