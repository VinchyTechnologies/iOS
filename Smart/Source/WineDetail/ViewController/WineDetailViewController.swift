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
import VinchyCore
import VinchyAuthorization

fileprivate enum C {
  
  static let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)
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
      section.contentInsets = .init(top: 0, leading: 0, bottom: 15, trailing: 0)
      return section
      
    case .winery:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 15, bottom: 0, trailing: 15)
      return section

    case .title, .text:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 5, leading: 15, bottom: 0, trailing: 15)
      return section
      
    case .rate:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 5, leading: 15, bottom: 0, trailing: 15)
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
      
    case .ratingAndReview:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)))
      let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 10, leading: 15, bottom: 0, trailing: 15)
      return section
      
    case .tapToRate:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)))
      let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
      return section
      
    case .reviews:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      let width: CGFloat = UIScreen.main.bounds.width > 320 ? 300 : 285
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(200)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
      section.interGroupSpacing = 10
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
      section.contentInsets = .init(top: 20, leading: 16, bottom: 20, trailing: 16)
      return section
      
    case .ad:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 0, bottom: 0, trailing: 0)
      return section
      
    case .similarWines:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 0, bottom: 0, trailing: 0)
      return section
    }
  }
  
  private lazy var collectionView: WineDetailCollectionView = {
    let collectionView = WineDetailCollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .mainBackground
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.delaysContentTouches = false
    
    collectionView.register(
      GalleryCell.self,
      TitleCopyableCell.self,
      TextCollectionCell.self,
      StarRatingControlCollectionCell.self,
      ToolCollectionCell.self,
      ShortInfoCollectionCell.self,
      ButtonCollectionCell.self,
      ImageOptionCollectionCell.self,
      TitleWithSubtitleInfoCollectionViewCell.self,
      BigAdCollectionCell.self,
      VinchySimpleConiniousCaruselCollectionCell.self,
      ReviewCell.self,
      RatingsAndReviewsCell.self,
      TapToRateCell.self)
    
    return collectionView
  }()

  private let noteButton = UIButton()
  private let moreButton = UIButton()

  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never

    noteButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: C.imageConfig), for: .normal)
    noteButton.backgroundColor = .option
    noteButton.contentEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
    noteButton.titleEdgeInsets = .init(top: 0, left: 2, bottom: 0, right: 2)
    noteButton.tintColor = .dark
    noteButton.addTarget(self, action: #selector(didTapNotes(_:)), for: .touchUpInside)

    let spacer = UIView(frame: .init(x: 0, y: 0, width: 2, height: 2))

    moreButton.setImage(UIImage(systemName: "ellipsis", withConfiguration: C.imageConfig), for: .normal)
    moreButton.backgroundColor = .option
    moreButton.contentEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
    moreButton.tintColor = .dark
    moreButton.addTarget(self, action: #selector(didTapMore(_:)), for: .touchUpInside)

    let moreBarButtonItem = UIBarButtonItem(customView: moreButton)
    let noteBarButtonItem = UIBarButtonItem(customView: noteButton)
    let spacerBarItem = UIBarButtonItem(customView: spacer)
    navigationItem.rightBarButtonItems = [moreBarButtonItem, spacerBarItem, noteBarButtonItem]
    
    view.addSubview(collectionView)
    collectionView.fill()
    
    interactor?.viewDidLoad()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
        self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    collectionView.contentInset = .init(top: 0, left: 0, bottom: 15, right: 0)
    noteButton.layer.cornerRadius = noteButton.bounds.width / 2
    moreButton.layer.cornerRadius = moreButton.bounds.width / 2
  }
  
  // MARK: - Private Methods
  
  @objc
  private func didTapNotes(_ button: UIButton) {
    interactor?.didTapNotes()
  }

  @objc
  private func didTapMore(_ button: UIButton) {
    interactor?.didTapMore(button)
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
      
    case .rate(let model):
      return model.count
      
    case .winery(let model):
      return model.count
      
    case .text(let model):
      return model.count
      
    case .tool(let model):
      return model.count
      
    case .list(let model):
      return model.count
      
    case .ratingAndReview(let model):
      return model.count
      
    case .tapToRate(let model):
      return model.count
      
    case .reviews(let model):
      return model.count
    
    case .servingTips(let model):
      return model.count
      
    case .button(let model):
      return model.count
      
    case .ad(let model):
      return model.count

    case .similarWines(let model):
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
      
    case .rate(let model):
    // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StarRatingControlCollectionCell.reuseId, for: indexPath) as! StarRatingControlCollectionCell
      cell.decorate(model: model[indexPath.row])
      return cell
            
    case .winery(let model), .text(let model):
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
      
    case .ratingAndReview(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingsAndReviewsCell.reuseId, for: indexPath) as! RatingsAndReviewsCell
      cell.decorate(model: model[indexPath.row])
      cell.delegate = self
      return cell
      
    case .tapToRate(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapToRateCell.reuseId, for: indexPath) as! TapToRateCell
      cell.decorate(model: model[indexPath.row])
      return cell
      
    case .reviews(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.reuseId, for: indexPath) as! ReviewCell
      cell.decorate(model: model[indexPath.row])
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

    case .similarWines(let model):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: VinchySimpleConiniousCaruselCollectionCell.reuseId,
        for: indexPath) as! VinchySimpleConiniousCaruselCollectionCell// swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      cell.delegate = self
      return cell
    }
  }
}

extension WineDetailViewController: UICollectionViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    navigationItem.title = scrollView.contentOffset.y > 300 ? viewModel?.navigationTitle : nil
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath)
  {
    guard let type = viewModel?.sections[indexPath.section] else {
      return
    }
    
    switch type {
    case .gallery, .title, .rate, .winery, .text, .tool, .list, .ratingAndReview, .tapToRate, .servingTips, .button, .ad, .similarWines:
      break
      
    case .reviews(let model):
      interactor?.didTapReview(reviewID: model[indexPath.row].id)
    }
  }
}

extension WineDetailViewController: ButtonCollectionCellDelegate {
  
  func didTapReviewButton(_ button: UIButton) {
    interactor?.didTapWriteReviewButton()
  }
}

extension WineDetailViewController: ToolCollectionCellDelegate {
  
  func didTapShare(_ button: UIButton) {
    interactor?.didTapShareButton(button)
  }
  
  func didTapLike(_ button: UIButton) {
    interactor?.didTapLikeButton(button)
  }
  
  func didTapPrice(_ button: UIButton) {
    interactor?.didTapPriceButton()
  }
}

extension WineDetailViewController: VinchySimpleConiniousCaruselCollectionCellDelegate {

  func didTapCompilationCell(wines: [ShortWine], title: String?) { }

  func didTapBottleCell(wineID: Int64) {
    interactor?.didTapSimilarWine(wineID: wineID)
  }
}

extension WineDetailViewController: WineDetailViewControllerProtocol {

  func updateUI(viewModel: WineDetailViewModel) {
    self.viewModel = viewModel
  }
}

extension WineDetailViewController: RatingsAndReviewsCellDelegate {
  func didTapSeeAllReview() {
    interactor?.didTapSeeAllReviews()
  }
}

extension WineDetailViewController: AuthorizationOutputDelegate {
  
  func didSuccessfullyLogin(output: AuthorizationOutputModel?) {
    interactor?.didSuccessfullyLoginOrRegister()
  }
  
  func didSuccessfullyRegister(output: AuthorizationOutputModel?) {
    interactor?.didSuccessfullyLoginOrRegister()
  }
}
