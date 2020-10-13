//
//  VinchyViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyCore
import Display
import CommonUI
import Core
import EmailService
import StringFormatting
// swiftlint:disable:force_cast

fileprivate enum C {
    static let horizontalInset: CGFloat = 20
}

final class VinchyViewController: UIViewController {

    // MARK: - Public Properties

    var interactor: VinchyInteractorProtocol?

    // MARK: - Private Properties

    private var sections = [VinchyViewControllerViewModel.Section]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private(set) var loadingIndicator = ActivityIndicatorView()

    private lazy var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .mainBackground

        collectionView.register(
            SuggestionCollectionCell.self,
            VinchySimpleConiniousCaruselCollectionCell.self,
            ShareUsCollectionCell.self,
            WineCollectionViewCell.self,
            AdsCollectionViewCell.self,
            SmartFilterCollectionCell.self,
            TextCollectionCell.self)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        collectionView.delaysContentTouches = false
        return collectionView
    }()

    private let refreshControl = UIRefreshControl()

    private lazy var resultsTableController: ResultsTableController = {
        let resultsTableController = ResultsTableController()
        resultsTableController.tableView.delegate = self
        resultsTableController.didnotFindTheWineTableCellDelegate = self
        return resultsTableController
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.font = Font.medium(20)
        searchController.searchBar.searchTextField.layer.cornerRadius = 20
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        searchController.searchBar.searchTextField.layer.cornerCurve = .continuous
        return searchController
    }()

    private var isSearchingMode: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private var suggestions: [Wine] = []

    var collectionList: [CollectionItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.frame = view.frame

        let filterBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(didTapFilter))
        navigationItem.rightBarButtonItems = [filterBarButtonItem]
        navigationItem.searchController = searchController

        refreshControl.tintColor = .dark
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

        interactor?.viewDidLoad()

    }

    @objc
    private func didTapFilter() {
        interactor?.didTapFilter()
    }

    @objc
    private func didPullToRefresh() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.refreshControl.endRefreshing()
            }
        }
        interactor?.didPullToRefresh()
        CATransaction.commit()
    }
}

extension VinchyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int)
        -> CGFloat
    {
        isSearchingMode ? 0 : 10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize
    {
        switch sections[indexPath.section] {
        case .title(let model):
            let width = collectionView.frame.width - 2 * C.horizontalInset
            let height = TextCollectionCell.height(viewModel: model[indexPath.row], width: width)
            return .init(width: width, height: height)

        case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
            return .init(width: collectionView.frame.width,
                         height: VinchySimpleConiniousCaruselCollectionCell.height(viewModel: model[indexPath.row]))
            
        case .suggestions(_):
            return .init(width: collectionView.frame.width, height: 44)

        case .shareUs(_):
            let width = collectionView.frame.width - 2 * C.horizontalInset
            let height: CGFloat = 150 // TODO: - 
            return .init(width: width, height: height)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
        -> UIEdgeInsets
    {
        switch sections[section] {
        case .title:
            return .init(top: 10, left: C.horizontalInset, bottom: 5, right: C.horizontalInset)

        case .suggestions:
            return .init(top: 0, left: C.horizontalInset, bottom: 0, right: C.horizontalInset)

        case .shareUs:
            return .init(top: 15, left: C.horizontalInset, bottom: 10, right: C.horizontalInset)

        case .stories, .promo, .big, .bottles:
            return .zero
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        isSearchingMode ? 1 : sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchingMode {
            return suggestions.count
        } else {
            switch sections[section] {
            case .title(let model):
                return model.count

            case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
                return model.count

            case .suggestions(let model):
                return model.count

            case .shareUs(let model):
                return model.count
            }
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        switch sections[indexPath.section] {
        case .title(let model):
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
            cell.decorate(model: model[indexPath.row])
            return cell

        case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VinchySimpleConiniousCaruselCollectionCell.reuseId,
                for: indexPath) as! VinchySimpleConiniousCaruselCollectionCell// swiftlint:disable:this force_cast
            cell.decorate(model: model[indexPath.row])
            cell.delegate = self
            return cell

        case .suggestions(let model):
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCollectionCell.reuseId, for: indexPath) as! SuggestionCollectionCell
            cell.decorate(model: model[indexPath.row])
            return cell

        case .shareUs(let model):
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareUsCollectionCell.reuseId, for: indexPath) as! ShareUsCollectionCell
            cell.decorate(model: model[indexPath.row])
            cell.delegate = self
            return cell
        }

        //            case .smartFilter:
        //                // swiftlint:disable:next force_cast
        //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmartFilterCollectionCell.reuseId, for: indexPath) as! SmartFilterCollectionCell
        //                cell.decorate(model: .init(
        //                                accentText: "New in Vinchy".uppercased(),
        //                                boldText: "Personal compilations",
        //                                subtitleText: "Answer on 3 questions & we find for you best wines.",
        //                                buttonText: "Try now"))
    }
}

extension VinchyViewController: UISearchBarDelegate {

    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String) {

        interactor?.didEnterSearchText(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        interactor?.didTapSearchButton(searchText: searchBar.text)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchingMode = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchingMode = false
    }
}

extension VinchyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        guard let wineID = suggestions[safe: indexPath.row]?.id else { return }
        navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
    }
}

extension VinchyViewController: DidnotFindTheWineTableCellProtocol {
    
    func didTapWriteUsButton(_ button: UIButton) {

        let searchText = searchController.searchBar.searchTextField.text
        interactor?.didTapDidnotFindWineFromSearch(
            searchText: searchText)
    }
}

extension VinchyViewController: VinchySimpleConiniousCaruselCollectionCellDelegate {

    func didTapBootleCell(wineID: Int64) {

        navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
    }

    func didTapCompilationCell(wines: [Wine], title: String?) {

        guard !wines.isEmpty else {
            showAlert(message: localized("empty_collection"))
            return
        }

        navigationController?.pushViewController(
            Assembly.buildShowcaseModule(navTitle: title, mode: .normal(wines: wines)), animated: true)
    }
}

extension VinchyViewController: VinchyViewControllerProtocol {

    func updateUI(didFindWines: [Wine]) {
        resultsTableController.didFoundProducts = didFindWines
    }

    func updateUI(sections: [VinchyViewControllerViewModel.Section]) {
        self.sections = sections
    }

    func updateSearchSuggestions(suggestions: [Wine]) {
        self.suggestions = suggestions
    }
}

extension VinchyViewController: ShareUsCollectionCellDelegate {

    func didTapShareUs(_ button: UIButton) {
        let items = [localized("i_use_vinchy"), openAppStoreURL]
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(controller, animated: true)
    }
}

//@objc private func didTapCamera() {
//    if let window = view.window {
//        let transition = CATransition()
//        transition.duration = 0.35
//        transition.type = .push
//        transition.subtype = .fromLeft
//        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        window.layer.add(transition, forKey: kCATransition)
//
//        let vc = VNDocumentCameraViewController()
//        vc.delegate = self
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: false, completion: nil)
//    }
//}
