//
//  WineDetailViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 24.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import CommonUI
import StringFormatting
import GoogleMobileAds

fileprivate enum C {
  
  static let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)
}

final class WineDetailViewController: UIViewController {
  
  // MARK: - Public Properties
  
  var interactor: WineDetailInteractorProtocol?
  
  // MARK: - Private Properties
  
  private(set) var loadingIndicator = ActivityIndicatorView()
  
  private var viewModel: WineDetailViewModel? {
    didSet {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  private lazy var layout = UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
    
    guard let self = self else { return nil }
    
    guard let type = self.viewModel?.sections[sectionNumber] else {
      return nil
    }
    
    switch type {
    case .gallery:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      return section

    case .title, .text:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 15, bottom: 0, trailing: 15)
      return section
      
    case .tool:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 15, bottom: 0, trailing: 15)
      return section
      
    case .list:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 0, bottom: 0, trailing: 0)
      return section
      
    case .servingTips:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(180), heightDimension: .fractionalHeight(1)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(180), heightDimension: .absolute(100)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = .init(top: 15, leading: 15, bottom: 0, trailing: 15)
      section.interGroupSpacing = 10
      return section
      
    case .button:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 20, leading: 16, bottom: 0, trailing: 16)
      return section
      
    case .ad:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 0, bottom: 0, trailing: 0)
      return section
    }
  }
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .mainBackground
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register(
      GalleryCell.self,
      TitleCopyableCell.self,
      TextCollectionCell.self,
      ToolCollectionCell.self,
      ShortInfoCollectionCell.self,
      ButtonCollectionCell.self,
      ImageOptionCollectionCell.self,
      TitleWithSubtitleInfoCollectionViewCell.self,
      BigAdCollectionCell.self)
    
    return collectionView
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "square.and.pencil",
                     withConfiguration: C.imageConfig),
      style: .plain,
      target: self,
      action: #selector(didTapNotes))
    
    navigationItem.rightBarButtonItem = rightBarButtonItem
    
    view.addSubview(collectionView)
    collectionView.frame = view.frame
    
    interactor?.viewDidLoad()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    collectionView.contentInset = .init(top: 0, left: 0, bottom: 15, right: 0)
  }
  
  // MARK: - Private Methods
  
  @objc
  private func didTapNotes() {
    interactor?.didTapNotes()
  }
}

// MARK: - UICollectionViewDataSource

extension WineDetailViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel?.sections.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    guard let type = viewModel?.sections[section] else {
      return 0
    }
    
    switch type {
    case .gallery(let model):
      return model.count

    case .title(let model):
      return model.count
      
    case .text(let model):
      return model.count
      
    case .tool(let model):
      return model.count
      
    case .list(let model):
      return model.count
      
    case .servingTips(let model):
      return model.count
      
    case .button(let model):
      return model.count
      
    case .ad(let model):
      return model.count
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
  -> UICollectionViewCell
  {
    
    guard let type = viewModel?.sections[indexPath.section] else {
      return .init()
    }
    
    switch type {
    case .gallery(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseId, for: indexPath) as! GalleryCell
      cell.decorate(model: model[indexPath.row])
      return cell

    case .title(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCopyableCell.reuseId, for: indexPath) as! TitleCopyableCell
      cell.decorate(model: model[indexPath.row])
      return cell
      
    case .text(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
      cell.decorate(model: model[indexPath.row])
      return cell
      
    case .tool(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolCollectionCell.reuseId, for: indexPath) as! ToolCollectionCell
      cell.decorate(model: model[indexPath.row])
      cell.delegate = self
      return cell
      
    case .list(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleWithSubtitleInfoCollectionViewCell.reuseId, for: indexPath) as! TitleWithSubtitleInfoCollectionViewCell
      cell.decorate(model: model[indexPath.row])
      cell.backgroundColor = indexPath.row.isMultiple(of: 2) ? .option : .mainBackground
      return cell
      
    case .servingTips(let model):
      let item = model[indexPath.row]
      switch item {
      case .titleTextAndImage(let imageName, let titleText):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageOptionCollectionCell.reuseId, for: indexPath) as! ImageOptionCollectionCell
        cell.decorate(model: .init(imageName: imageName, titleText: titleText, isSelected: false))
        return cell
        
      case .titleTextAndSubtitleText(let titleText, let subtitleText):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortInfoCollectionCell.reuseId, for: indexPath) as! ShortInfoCollectionCell
        let title = NSAttributedString(string: titleText ?? "", font: Font.with(size: 24, design: .round, traits: .bold), textColor: .dark)
        let subtitle = NSAttributedString(string: subtitleText ?? "", font: Font.with(size: 18, design: .round, traits: .bold), textColor: .blueGray)
        cell.decorate(model: .init(title: title, subtitle: subtitle))
        return cell
      }
      
    case .button(let model):
      //swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionCell.reuseId, for: indexPath) as! ButtonCollectionCell
      cell.decorate(model: model[indexPath.row])
      cell.delegate = self
      return cell
      
    case .ad: // TODO: - configure string key
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigAdCollectionCell.reuseId, for: indexPath) as! BigAdCollectionCell
      cell.adBanner.rootViewController = self
      return cell
    }
  }
}

extension WineDetailViewController: UICollectionViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    navigationItem.title = scrollView.contentOffset.y > 300 ? viewModel?.navigationTitle : nil
  }
}

extension WineDetailViewController: ButtonCollectionCellDelegate {
  
  func didTapDislikeButton(_ button: UIButton) {
    button.isSelected = !button.isSelected
    interactor?.didTapDislikeButton(button)
  }
  
  func didTapReportAnErrorButton(_ button: UIButton) {
    interactor?.didTapReportAnError()
  }
}

extension WineDetailViewController: ToolCollectionCellDelegate {
  
  func didTapShare(_ button: UIButton) {
    interactor?.didTapShareButton()
  }
  
  func didTapLike(_ button: UIButton) {
    interactor?.didTapLikeButton(button)
  }
  
  func didTapPrice(_ button: UIButton) {
    interactor?.didTapPriceButton()
  }
}

extension WineDetailViewController: WineDetailViewControllerProtocol {
  
  func updateUI(viewModel: WineDetailViewModel) {
    self.viewModel = viewModel
  }
}
