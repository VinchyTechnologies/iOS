//
//  NewVinchyViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 17.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

//import UIKit
//import VinchyCore
//import Display
//import CommonUI
//import Core
//import EmailService
//import StringFormatting
////import GoogleMobileAds
//
//fileprivate enum SectionType: Hashable {
//    case story(model: StoryCollectionCellViewModel)
//    case subtitle(model: MainSubtitleCollectionCellViewModel)
//    case bottles(model: [WineCollectionViewCellViewModel])
//    case shareUs(model: ShareUsCollectionCellViewModel)
//    case infinity(model: WineCollectionViewCellViewModel)
//}
//
//fileprivate enum SearchSectionType: Hashable {
//    case suggestion(model: SuggestionCollectionCellViewModel)
//}
//
//fileprivate let sectionHeaderElementKind = "section-header-element-kind"
//fileprivate let sectionFooterElementKind = "section-footer-element-kind"
//
//final class NewVinchyViewController: UIViewController, Loadable, Alertable {
//
//    private enum C {
//        static let numberNoBackendSections: Int = 0
//    }
//
////    private lazy var adLoader: GADAdLoader =  {
////        let options = GADMultipleAdsAdLoaderOptions()
////
////        let op = GADNativeAdMediaAdLoaderOptions()
////        op.mediaAspectRatio = .landscape
////
////        let loader = GADAdLoader(adUnitID: "ca-app-pub-6194258101406763/5059597902",
////                            rootViewController: self,
////                            adTypes: [.unifiedNative],
////                            options: [options, op])
//////        loader.delegate = self
////        return loader
////    }()
//
//    private(set) var loadingIndicator = ActivityIndicatorView()
//
//    private lazy var collectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .mainBackground
//        collectionView.delegate = self
//        collectionView.refreshControl = refreshControl
//        collectionView.delaysContentTouches = false
//        return collectionView
//    }()
//
//    private let dispatchGroup = DispatchGroup()
//    private let refreshControl = UIRefreshControl()
//    private lazy var resultsTableController: ResultsTableController = {
//        let resultsTableController = ResultsTableController()
//        resultsTableController.tableView.delegate = self
//        resultsTableController.didnotFindTheWineTableCellDelegate = self
//        return resultsTableController
//    }()
//
//    private lazy var searchController: UISearchController = {
//        let searchController = UISearchController(searchResultsController: resultsTableController)
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.autocapitalizationType = .none
//        searchController.searchBar.delegate = self
//        searchController.searchBar.searchTextField.font = Font.medium(20)
//        searchController.searchBar.searchTextField.layer.cornerRadius = 20
//        searchController.searchBar.searchTextField.layer.masksToBounds = true
//        searchController.searchBar.searchTextField.layer.cornerCurve = .continuous
//        return searchController
//    }()
//
//    private let emailService = EmailService()
//    private var searchText: String?
//
//    private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
//        guard let self = self else { return }
//        self.addLoader()
//        self.startLoadingAnimation()
//    }
//
//    private var isSearchingMode: Bool = false {
//        didSet {
//            if isSearchingMode {
//                configureDataSource(suggestions: suggestions)
//            } else {
//                configureDataSource(compilations: compilations)
//            }
//        }
//    }
//
//    private lazy var searchWorkItem = WorkItem()
//
//    private var suggestions: [Wine] = []
//
//    var collectionList: [CollectionItem] = []
//
//    private var compilations: [Compilation] = [] {
//        didSet {
//            loadViewIfNeeded()
//            configureDataSource(compilations: compilations)
//        }
//    }
//
//    fileprivate var dataSource: UICollectionViewDiffableDataSource<Int, SectionType>! = nil
//    fileprivate var searchDataSource: UICollectionViewDiffableDataSource<Int, SearchSectionType>! = nil
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        fetchData()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.dispatchWorkItemHud.perform()
//        }
//    }
//
//    required init?(coder: NSCoder) { fatalError() }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.addSubview(collectionView)
//        let filterBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(didTapFilter))
//        navigationItem.rightBarButtonItems = [filterBarButtonItem]
//        navigationItem.searchController = searchController
//        refreshControl.tintColor = .dark
//        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
//    }
//
//    private func fetchData() {
//
//        dispatchGroup.enter()
//        var compilations: [Compilation] = []
//        Compilations.shared.getCompilations { [weak self] result in
//            switch result {
//            case .success(let model):
//                compilations = model
//            case .failure:
//                break
//            }
//            self?.dispatchGroup.leave()
//        }
//
////        var infinityWines: [Wine] = []
////        dispatchGroup.enter()
////        Wines.shared.getRandomWines(count: 10) { [weak self] result in
////            switch result {
////            case .success(let model):
////                infinityWines = model
////            case .failure:
////                break
////            }
////            self?.dispatchGroup.leave()
////        }
//
//        dispatchGroup.notify(queue: .main) { [weak self] in
//            guard let self = self else { return }
//            self.dispatchWorkItemHud.cancel()
//            self.stopLoadingAnimation()
//
//            let shareUs = Compilation(type: .shareUs, title: nil, collectionList: [Collection(wineList: [])])
//            compilations.insert(shareUs, at: compilations.isEmpty ? 0 : compilations.count - 1)
//
////            if infinityWines.isEmpty {
////                self.compilations = compilations
////            } else {
////                self.adLoader.load(DFPRequest())
////                self.collectionList = infinityWines.map({ .wine(wine: $0) })
////                let collection = Collection(wineList: self.collectionList)
////                let compilation = Compilation(type: .infinity, title: "You can like", collectionList: [collection])
////
////                compilations.append(compilation)
////                self.compilations = compilations
////            }
//        }
//
//        Wines.shared.getRandomWines(count: 10) { [weak self] result in
//            switch result {
//            case .success(let model):
//                self?.suggestions = model
//            case .failure:
//                break
//            }
//        }
//    }
//
//    private lazy var layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionInt, env) -> NSCollectionLayoutSection? in
//
//        if self.isSearchingMode {
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .fractionalHeight(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            item.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                   heightDimension: .absolute(44))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//            let section = NSCollectionLayoutSection(group: group)
//            return section
//        }
//
//        let section: NSCollectionLayoutSection
//        let width: NSCollectionLayoutDimension
//        let height: NSCollectionLayoutDimension
//
//        switch self.compilations[sectionInt].type.itemSize.width {
//        case .absolute(let _width):
//            width = .absolute(_width)
//
//        case .dimension(let _width):
//            width = .fractionalWidth(_width)
//        }
//
//        switch self.compilations[sectionInt].type.itemSize.height {
//        case .absolute(let _width):
//            height = .absolute(_width)
//
//        case .dimension(let _width):
//            height = .fractionalWidth(_width)
//        }
//
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
//        let groupSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        section = NSCollectionLayoutSection(group: group)
//
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .estimated(44)),
//            elementKind: sectionHeaderElementKind,
//            alignment: .topLeading)
//
//        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .absolute(44)),
//            elementKind: sectionFooterElementKind,
//            alignment: .bottom)
//
//        switch self.compilations[safe: sectionInt]?.type {
//        case .mini:
//            section.orthogonalScrollingBehavior = .continuous
//
//        case .big:
//            section.boundarySupplementaryItems = [sectionHeader]
//            section.orthogonalScrollingBehavior = .continuous
//
//        case .promo:
//            section.boundarySupplementaryItems = [sectionHeader]
//            section.orthogonalScrollingBehavior = .paging
//
//        case .bottles:
//            section.boundarySupplementaryItems = [sectionHeader]
//            section.orthogonalScrollingBehavior = .continuous
//
//        case .shareUs:
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                   heightDimension: .estimated(160))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//            let section = NSCollectionLayoutSection(group: group)
//            section.contentInsets = .init(top: 15, leading: 15, bottom: 15, trailing: 15)
//            return section
//
//        case .infinity:
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                   heightDimension: .absolute(255))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
////            let spacing = CGFloat(10)
////            group.interItemSpacing = .fixed(spacing)
////            group.edgeSpacing = .init(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(10))
//            let section = NSCollectionLayoutSection(group: group)
//
//            sectionHeader.pinToVisibleBounds = true
//            sectionHeader.zIndex = 2
////            section.contentInsets = .init(top: 15, leading: 15, bottom: 15, trailing: 15)
//            section.boundarySupplementaryItems = [sectionHeader]
//
//            return section
//
//        case .none:
//            return nil
//        }
//
//        if sectionInt == self.compilations.endIndex - 1 - C.numberNoBackendSections {
//            section.boundarySupplementaryItems.append(sectionFooter)
//        }
//
//        section.contentInsets = .init(top: 0, leading: 10, bottom: 10, trailing: 10)
//        return section
//
//    }, configuration: UICollectionViewCompositionalLayoutConfiguration())
//
//    @objc
//    private func refresh() {
//        CATransaction.begin()
//        CATransaction.setCompletionBlock {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.refreshControl.endRefreshing()
//            }
//        }
//        collectionView.reloadData()
//        CATransaction.commit()
//    }
//
//    @objc
//    private func didTapFilter() {
//        navigationController?.pushViewController(Assembly.buildFiltersModule(), animated: true)
//    }
//
////    private func loadMoreInfinity() {
////        adLoader.load(DFPRequest())
////
////        Wines.shared.getRandomWines(count: 10) { [weak self] result in
////            guard let self = self else { return }
////            switch result {
////            case .success(let model):
////                let collectionList: [CollectionItem] = model.map({ .wine(wine: $0) })
////                self.collectionList += collectionList
////                DispatchQueue.main.async {
////                    self.collectionView.reloadData()
////                }
////            case .failure:
////                break
////            }
////        }
////    }
//}
//
//extension NewVinchyViewController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if let resultsController = searchController.searchResultsController as? ResultsTableController {
//            searchWorkItem.perform(after: 0.65) {
//                guard searchText != "" else { return }
//                Wines.shared.getWineBy(title: searchText, offset: 0, limit: 40) { result in
//                    switch result {
//                    case .success(let wines):
//                        resultsController.didFoundProducts = wines
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                        // TODO: - error show may be???
//                        break
//                    }
//                }
//            }
//        }
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//
//        guard let searchString = searchBar.text else {
//            return
//        }
//
//        navigationController?.pushViewController(Assembly.buildShowcaseModule(navTitle: nil, mode: .advancedSearch(params: [("title", searchString)])), animated: true)
//    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        isSearchingMode = true
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        isSearchingMode = false
//    }
//}
//
//
//extension NewVinchyViewController {
//
//    func configureDataSource(suggestions: [Wine]) {
//
//        let suggestCellRegistration = UICollectionView.CellRegistration<SuggestionCollectionCell, SuggestionCollectionCellViewModel> { (cell, indexPath, model) in
//            cell.decorate(model: model)
//        }
//
//        searchDataSource = UICollectionViewDiffableDataSource<Int, SearchSectionType>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, searchType) -> UICollectionViewCell? in
//            switch searchType {
//            case .suggestion(let model):
//                return collectionView.dequeueConfiguredReusableCell(using: suggestCellRegistration, for: indexPath, item: model)
//            }
//        })
//
//        let sections = Array(0..<1)
//        var snapshot = NSDiffableDataSourceSnapshot<Int, SearchSectionType>()
//        sections.enumerated().forEach {
//            snapshot.appendSections([$1])
//            let suggestionViewModels = suggestions.compactMap { (wine) -> SearchSectionType? in
//                return  .suggestion(model: .init(titleText: wine.title))
//            }
//            snapshot.appendItems(suggestionViewModels)
//        }
//
//        searchDataSource.apply(snapshot, animatingDifferences: false)
//    }
//
//    func configureDataSource(compilations: [Compilation]) {
//
//        let storiesCellRegistration = UICollectionView.CellRegistration<StoryCollectionCell, StoryCollectionCellViewModel> { (cell, indexPath, model) in
//            cell.decorate(model: model)
//        }
//
//        let subtitleCollectionCellRegistration = UICollectionView.CellRegistration<MainSubtitleCollectionCell, MainSubtitleCollectionCellViewModel> { (cell, indexPath, model) in
//            cell.decorate(model: model)
//        }
//
//        let bottlesCollectionCellRegistration = UICollectionView.CellRegistration<WineCollectionViewCell, [WineCollectionViewCellViewModel]> { (cell, indexPath, model) in
//            cell.decorate(model: model[indexPath.row])
//        }
//
//        let infinityCollectionCellRegistration = UICollectionView.CellRegistration<WineCollectionViewCell, WineCollectionViewCellViewModel> { (cell, indexPath, model) in
//            cell.decorate(model: model)
//        }
//
//        let shareUsCollectionCellRegistration = UICollectionView.CellRegistration<ShareUsCollectionCell, ShareUsCollectionCellViewModel> { (cell, indexPath, model) in
//            cell.decorate(model: model)
//        }
//
//        let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderCollectionReusableView>(elementKind: sectionHeaderElementKind) { (supplementaryView, string, indexPath) in
//            let title = compilations[safe: indexPath.section]?.title ?? ""
//            let model = HeaderCollectionReusableViewModel(titleText: .init(string: title, font: Font.heavy(20), textColor: .dark))
//            supplementaryView.backgroundColor = .red
//            supplementaryView.decorate(model: model)
//        }
//
//        let footerRegistration = UICollectionView.SupplementaryRegistration<HeaderCollectionReusableView>(elementKind: sectionHeaderElementKind) { (supplementaryView, string, indexPath) in
//            let title = "Чрезмерное употребление алкоголя\nвредит вашему здоровью"
//            let model = HeaderCollectionReusableViewModel(titleText: .init(NSAttributedString(string: title, font: Font.light(15), textColor: .blueGray, paragraphAlignment: .justified)))
//            supplementaryView.decorate(model: model)
//        }
//
//        dataSource = UICollectionViewDiffableDataSource<Int, SectionType>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, sectionType) -> UICollectionViewCell? in
//
//            switch sectionType {
//            case .story(let model):
//                return collectionView.dequeueConfiguredReusableCell(using: storiesCellRegistration, for: indexPath, item: model)
//
//            case .subtitle(let model):
//                return collectionView.dequeueConfiguredReusableCell(using: subtitleCollectionCellRegistration, for: indexPath, item: model)
//
//            case .bottles(let model):
//                return collectionView.dequeueConfiguredReusableCell(using: bottlesCollectionCellRegistration, for: indexPath, item: model)
//
//            case .shareUs(let model):
//                return collectionView.dequeueConfiguredReusableCell(using: shareUsCollectionCellRegistration, for: indexPath, item: model)
//
//            case .infinity(let model):
//                return collectionView.dequeueConfiguredReusableCell(using: infinityCollectionCellRegistration, for: indexPath, item: model)
//            }
//        })
//
//        dataSource.supplementaryViewProvider = { (view, kind, index) in
//            return self.collectionView.dequeueConfiguredReusableSupplementary(
//                using: kind == sectionHeaderElementKind ? headerRegistration : footerRegistration, for: index)
//        }
//
//        let sections = Array(0..<compilations.count)
//
//        var snapshot = NSDiffableDataSourceSnapshot<Int, SectionType>()
//        sections.enumerated().forEach {
//            snapshot.appendSections([$1])
//            let compilation = compilations[$0]
//            let storyCollectionCellViewModels = compilation.collectionList.compactMap { (collection) -> SectionType? in
//                switch compilation.type {
//                case .mini:
//                    return .story(model: StoryCollectionCellViewModel(imageURL: collection.imageURL?.toURL,
//                                                                      titleText: collection.title))
//                case .big, .promo:
//                    return .subtitle(model: MainSubtitleCollectionCellViewModel(subtitleText: collection.title,
//                                                                                imageURL: collection.imageURL?.toURL))
//                case .bottles:
//
//                    guard let col = compilation.collectionList.first else {
//                        return nil
//                    }
//
//                    return SectionType.bottles(model: col.wineList.compactMap({ (collectionItem) -> WineCollectionViewCellViewModel? in
//
//                        switch collectionItem {
//                        case .wine(let wine):
//                            return WineCollectionViewCellViewModel(imageURL: wine.mainImageUrl?.toURL, titleText: wine.title, subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode), backgroundColor: .option)
//
//                        case .ads:
//                            return nil
//                        }
//                    }))
//
//                case .shareUs:
//                    return .shareUs(model: .init(titleText: "Like the app?"))
//
//                case .infinity:
//                    return nil
//                }
//            }
//
//            snapshot.appendItems(storyCollectionCellViewModels)
//        }
//
//        if let infinityItems = compilations.last?.collectionList.first?.wineList.compactMap({ (collectionItem) -> SectionType? in
//            switch collectionItem {
//            case .wine(let wine):
//                return .infinity(model: .init(imageURL: wine.mainImageUrl?.toURL, titleText: wine.title, subtitleText: wine.winery?.countryCode, backgroundColor: .option))
//            case .ads:
//                return nil
//            }
//        }) {
//            snapshot.appendItems(infinityItems)
////            snapshot.appendItems(infinityItems, toSection: sections.count - 1)
//        }
//
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
//}
//
//extension NewVinchyViewController: UICollectionViewDelegate {
//
////    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
////        if !isSearchingMode {
////            switch compilations[indexPath.section].type {
////            case .mini, .big, .promo, .bottles, .shareUs:
////                break
////            case .infinity:
////                if indexPath.row == collectionList.count - 4 {
////                    loadMoreInfinity()
////                }
////            }
////        }
////    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        if isSearchingMode {
//            guard let wineID = suggestions[safe: indexPath.row]?.id else {
//                return
//            }
//            navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
//            return
//        }
//
//        switch compilations[indexPath.section].type {
//        case .mini, .big, .promo:
//            let wines = compilations[indexPath.section].collectionList[indexPath.row].wineList.compactMap { (collectionItem) -> Wine? in
//                switch collectionItem {
//                case .wine(let wine):
//                    return wine
//                case .ads:
//                    return nil
//                }
//            }
//            
//            navigationController?.pushViewController(Assembly.buildShowcaseModule(navTitle: compilations[indexPath.section].title, mode: .normal(wines: wines)), animated: true)
//
//        case .bottles:
//            if let wine = compilations[indexPath.section].collectionList.first?.wineList[indexPath.row] {
//                switch wine {
//                case .wine(let wine):
//                    navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wine.id), animated: true)
//                case .ads:
//                    break
//                }
//            }
//        case .shareUs:
//            break
//
//        case .infinity:
//            break
//        }
//    }
//}
//
//extension NewVinchyViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        guard let wineID = suggestions[safe: indexPath.row]?.id else { return }
//        navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
//    }
//}
//
//extension NewVinchyViewController: DidnotFindTheWineTableCellProtocol {
//    func didTapWriteUsButton(_ button: UIButton) {
//        // TODO: - localize
//        if emailService.canSend && searchText != nil {
//            let emailController = emailService.getEmailController(HTMLText: "Привет я не нашел вино с названием " + (searchText ?? ""), recipients: [localized("contact_email")])
//            present(emailController, animated: true, completion: nil)
//        } else {
//            showAlert(message: "Возникла ошибка при открытии почты")
//        }
//    }
//}
