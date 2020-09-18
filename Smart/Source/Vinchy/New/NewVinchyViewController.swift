//
//  NewVinchyViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 17.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import MagazineLayout
import VinchyCore
import Display
import CommonUI
import Core
import EmailService
import StringFormatting
import GoogleMobileAds

fileprivate enum SectionType: Hashable {
    case story(model: StoryCollectionCellViewModel)
    case subtitle(model: MainSubtitleCollectionCellViewModel)
    case bottles(model: [WineCollectionViewCellViewModel])
}

fileprivate let sectionHeaderElementKind = "section-header-element-kind"
fileprivate let sectionFooterElementKind = "section-footer-element-kind"

final class NewVinchyViewController: UIViewController, Loadable, Alertable {

    private lazy var adLoader: GADAdLoader =  {
        let options = GADMultipleAdsAdLoaderOptions()

        let op = GADNativeAdMediaAdLoaderOptions()
        op.mediaAspectRatio = .landscape

        let loader = GADAdLoader(adUnitID: "ca-app-pub-6194258101406763/5059597902",
                            rootViewController: self,
                            adTypes: [.unifiedNative],
                            options: [options, op])
//        loader.delegate = self
        return loader
    }()

    private(set) var loadingIndicator = ActivityIndicatorView()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: MagazineLayout())
        collectionView.backgroundColor = .mainBackground
//        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        collectionView.delaysContentTouches = false
        return collectionView
    }()

    private let dispatchGroup = DispatchGroup()
    private let refreshControl = UIRefreshControl()
//    private lazy var resultsTableController: ResultsTableController = {
//        let resultsTableController = ResultsTableController()
//        resultsTableController.tableView.delegate = self
//        resultsTableController.didnotFindTheWineTableCellDelegate = self
//        return resultsTableController
//    }()

//    private lazy var searchController: UISearchController = {
//        let searchController = UISearchController(searchResultsController: resultsTableController)
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.autocapitalizationType = .none
////        searchController.searchBar.delegate = self
//        searchController.searchBar.searchTextField.font = Font.medium(20)
//        searchController.searchBar.searchTextField.layer.cornerRadius = 20
//        searchController.searchBar.searchTextField.layer.masksToBounds = true
//        searchController.searchBar.searchTextField.layer.cornerCurve = .continuous
//        return searchController
//    }()

    private let emailService = EmailService()
    private var searchText: String?

    private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
        guard let self = self else { return }
        self.addLoader()
        self.startLoadingAnimation()
    }

    private var isSearchingMode: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private lazy var searchWorkItem = WorkItem()

    private var suggestions: [Wine] = []

    var collectionList: [CollectionItem] = []

    private var compilations: [Compilation] = [] {
        didSet {
            loadViewIfNeeded()
            configureDataSource(compilations: compilations)
        }
    }

    fileprivate var dataSource: UICollectionViewDiffableDataSource<Int, SectionType>! = nil

    init() {
        super.init(nibName: nil, bundle: nil)
        fetchData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dispatchWorkItemHud.perform()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        let filterBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(didTapFilter))
        navigationItem.rightBarButtonItems = [filterBarButtonItem]
//        navigationItem.searchController = searchController
        refreshControl.tintColor = .dark
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    private func fetchData() {

        dispatchGroup.enter()
        var compilations: [Compilation] = []
        Compilations.shared.getCompilations { [weak self] result in
            switch result {
            case .success(let model):
                compilations = model
            case .failure:
                break
            }
            self?.dispatchGroup.leave()
        }

        var infinityWines: [Wine] = []
        dispatchGroup.enter()
        Wines.shared.getRandomWines(count: 10) { [weak self] result in
            switch result {
            case .success(let model):
                infinityWines = model
            case .failure:
                break
            }
            self?.dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.dispatchWorkItemHud.cancel()
            self.stopLoadingAnimation()

            let shareUs = Compilation(type: .shareUs, title: nil, collectionList: [])
            compilations.insert(shareUs, at: compilations.isEmpty ? 0 : compilations.count - 1)

            if infinityWines.isEmpty {
                self.compilations = compilations
            } else {
                self.adLoader.load(DFPRequest())
                self.collectionList = infinityWines.map({ .wine(wine: $0) })
                let collection = Collection(wineList: self.collectionList)
                compilations.append(Compilation(type: .infinity, title: "You can like", collectionList: [collection]))
                self.compilations = compilations
            }
        }

        Wines.shared.getRandomWines(count: 10) { [weak self] result in
            switch result {
            case .success(let model):
                self?.suggestions = model
            case .failure:
                break
            }
        }
    }

    private lazy var layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionInt, env) -> NSCollectionLayoutSection? in

        let section: NSCollectionLayoutSection
        let width: NSCollectionLayoutDimension
        let height: NSCollectionLayoutDimension

        switch self.compilations[sectionInt].type.itemSize.width {
        case .absolute(let _width):
            width = .absolute(_width)

        case .dimension(let _width):
            width = .fractionalWidth(_width)
        }

        switch self.compilations[sectionInt].type.itemSize.height {
        case .absolute(let _width):
            height = .absolute(_width)

        case .dimension(let _width):
            height = .fractionalWidth(_width)
        }

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        section = NSCollectionLayoutSection(group: group)

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(44)),
            elementKind: sectionHeaderElementKind,
            alignment: .top)

        switch self.compilations[safe: sectionInt]?.type {
        case .mini:
            section.orthogonalScrollingBehavior = .continuous

        case .big:
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .continuous

        case .promo:
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .paging

        case .bottles:
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .continuous

        case .none, .shareUs, .infinity:
            return nil
        }

        section.contentInsets = .init(top: 0, leading: 10, bottom: 10, trailing: 10)
        return section

    }, configuration: UICollectionViewCompositionalLayoutConfiguration())

    @objc
    private func refresh() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.refreshControl.endRefreshing()
            }
        }
        collectionView.reloadData()
        CATransaction.commit()
    }

    @objc
    private func didTapFilter() {
        navigationController?.pushViewController(Assembly.buildFiltersModule(), animated: true)
    }
}

extension NewVinchyViewController {

    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }

    func configureDataSource(compilations: [Compilation]) {

        let storiesCellRegistration = UICollectionView.CellRegistration<StoryCollectionCell, StoryCollectionCellViewModel> { (cell, indexPath, model) in
            cell.decorate(model: model)
        }

        let subtitleCollectionCellRegistration = UICollectionView.CellRegistration<MainSubtitleCollectionCell, MainSubtitleCollectionCellViewModel> { (cell, indexPath, model) in
            cell.decorate(model: model)
        }

        let bottlesCollectionCellRegistration = UICollectionView.CellRegistration<WineCollectionViewCell, [WineCollectionViewCellViewModel]> { (cell, indexPath, model) in
            cell.decorate(model: model[indexPath.row])
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderCollectionReusableView>(elementKind: sectionHeaderElementKind) { (supplementaryView, string, indexPath) in
            let title = compilations[safe: indexPath.section]?.title ?? ""
            let model = HeaderCollectionReusableViewModel(titleText: .init(string: title, font: Font.heavy(20), textColor: .dark))
            supplementaryView.decorate(model: model)
        }

        dataSource = UICollectionViewDiffableDataSource<Int, SectionType>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, sectionType) -> UICollectionViewCell? in

            switch sectionType {
            case .story(let model):
                return collectionView.dequeueConfiguredReusableCell(using: storiesCellRegistration, for: indexPath, item: model)

            case .subtitle(let model):
                return collectionView.dequeueConfiguredReusableCell(using: subtitleCollectionCellRegistration, for: indexPath, item: model)

            case .bottles(let model):
                return collectionView.dequeueConfiguredReusableCell(using: bottlesCollectionCellRegistration, for: indexPath, item: model)
            }
        })

        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: /*kind == sectionHeaderElementKind ? headerRegistration : footerRegistration*/headerRegistration, for: index)
        }

        let sections = Array(0..<compilations.count)
        var snapshot = NSDiffableDataSourceSnapshot<Int, SectionType>()
        sections.enumerated().forEach {
            snapshot.appendSections([$1])
            let compilation = compilations[$1]
            let storyCollectionCellViewModels = compilation.collectionList.compactMap { (collection) -> SectionType? in
                switch compilation.type {
                case .mini:
                    return .story(model: StoryCollectionCellViewModel(imageURL: collection.imageURL?.toURL,
                                                                      titleText: collection.title))
                case .big, .promo:
                    return .subtitle(model: MainSubtitleCollectionCellViewModel(subtitleText: collection.title,
                                                                                imageURL: collection.imageURL?.toURL))
                case .bottles:

                    guard let col = compilation.collectionList.first else {
                        return nil
                    }

                    return SectionType.bottles(model: col.wineList.compactMap({ (collectionItem) -> WineCollectionViewCellViewModel? in

                        switch collectionItem {
                        case .wine(let wine):
                            return WineCollectionViewCellViewModel(imageURL: wine.mainImageUrl?.toURL, titleText: wine.title, subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode), backgroundColor: .option)

                        case .ads:
                            return nil
                        }
                    }))

                case .shareUs:
                    return nil

                case .infinity:
                    return nil
                }
            }

            snapshot.appendItems(storyCollectionCellViewModels)
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension NewVinchyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print(indexPath)
    }
}
