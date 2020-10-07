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

final class VinchyViewController: UIViewController, Alertable, Loadable {

    // MARK: - Public Properties

    var interactor: VinchyInteractorProtocol?

    // MARK: - Private Properties

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
            SmartFilterCollectionCell.self)

        collectionView.register(
            HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderCollectionReusableView.reuseId)

        collectionView.register(
            VinchyFooterCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: VinchyFooterCollectionReusableView.reuseId)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        collectionView.delaysContentTouches = false
        return collectionView
    }()

    private let dispatchGroup = DispatchGroup()
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

//        let searchIcon = UIImage(systemName: "magnifyingglass")?.withTintColor(.blueGray, renderingMode: .alwaysOriginal)
//        searchController.searchBar.setImage(searchIcon, for: .search, state: .normal)
//        searchController.searchBar.searchTextField.backgroundColor = .option
////        searchController.searchBar.tintColor = .blueGray
//        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: localized("search").firstLetterUppercased(), font: Font.bold(20), textColor: .blueGray)
        return searchController
    }()

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
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()

        interactor?.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dispatchWorkItemHud.perform()
        }

        view.addSubview(collectionView)
        collectionView.frame = view.frame
        let filterBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(didTapFilter))
        navigationItem.rightBarButtonItems = [filterBarButtonItem]
        navigationItem.searchController = searchController
        refreshControl.tintColor = .dark
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    @objc
    private func didTapFilter() {
        navigationController?.pushViewController(Assembly.buildFiltersModule(), animated: true)
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

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.dispatchWorkItemHud.cancel()
            self.stopLoadingAnimation()

            let shareUs = Compilation(type: .shareUs, title: nil, collectionList: [])
            compilations.insert(shareUs, at: compilations.isEmpty ? 0 : compilations.count - 1)

            if isSmartFilterAvailable {
                let smartFilter = Compilation(type: .smartFilter, title: nil, collectionList: [])
                compilations.insert(smartFilter, at: 1)
            }

            self.compilations = compilations
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

    @objc
    private func refresh() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.refreshControl.endRefreshing()
            }
        }
        fetchData()
        CATransaction.commit()
    }
}

extension VinchyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if isSearchingMode {
            return 0
        }
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearchingMode {
            guard let wineID = suggestions[safe: indexPath.row]?.id else { return }
            navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
        } else {
            switch compilations[safe: indexPath.section]?.type {
            case .mini, .big, .promo, .bottles, .shareUs, .none:
                return
            case .smartFilter:
                // TODO: - show pager
                break
            case .infinity:
                switch collectionList[safe: indexPath.row] {
                case .wine(let wine):
                    navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wine.id), animated: true)
                case .ads, .none:
                    return
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isSearchingMode {
            return .init(width: collectionView.frame.width, height: 44)
        }

        guard let row = compilations[safe: indexPath.section] else {
            return .init(width: collectionView.frame.width, height: 0)
        }

        let height: CGFloat
        switch row.type.itemSize.height {
        case .absolute(let _height):
            height = _height + 5
        case .dimension:
            height = 0
        }

        switch row.type {
        case .mini, .big, .promo, .bottles:
            return .init(width: collectionView.frame.width, height: height)
        case .shareUs:
            return .init(width: collectionView.frame.width - 40, height: height)
        case .smartFilter:
            return .init(width: collectionView.frame.width - 40, height: 180)
        case .infinity:
            switch collectionList[indexPath.row] {
            case .wine:
                return .init(width: collectionView.frame.width / 2 - 10 * 2, height: height)
            case .ads:
                return .init(width: collectionView.frame.width, height: 100)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if isSearchingMode {
            return .init(top: 0, left: 20, bottom: 0, right: 20)
        }

        guard let row = compilations[safe: section] else {
            return .zero
        }

        switch row.type {
        case .mini:
            return .init(top: 0, left: 0, bottom: 10, right: 0)

        case .smartFilter:
            return .init(top: 0, left: 20, bottom: 10, right: 20)

        case .big, .promo, .bottles:
            return .init(top: 0, left: 0, bottom: 10, right: 0)

        case .shareUs:
            return .init(top: 10, left: 20, bottom: 10, right: 20)

        case .infinity:
            return .init(top: 0, left: 10, bottom: 0, right: 10)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        if isSearchingMode {
            return .zero
        }

        guard let row = compilations[safe: section] else {
            return .zero
        }

        switch row.type {
        case .mini, .smartFilter:
            return .zero
        case .big:
            return .init(width: collectionView.frame.width, height: 35)
        case .promo:
            return .init(width: collectionView.frame.width, height: 35)
        case .bottles:
            return .init(width: collectionView.frame.width, height: 35)
        case .shareUs:
            return .zero
        case .infinity:
            return .init(width: collectionView.frame.width, height: 35)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == compilations.count - 1 {
            return .init(width: collectionView.frame.width, height: 50)
        }
        return .zero
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        isSearchingMode ? 1 : compilations.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchingMode {
            return suggestions.count
        } else {
            switch compilations[section].type {
            case .mini, .big, .promo, .bottles, .shareUs, .smartFilter:
                return 1
            case .infinity:
                return collectionList.count
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if isSearchingMode {
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCollectionCell.reuseId, for: indexPath) as! SuggestionCollectionCell
            cell.decorate(model: .init(titleText: suggestions[indexPath.row].title))
            return cell

        } else {
            guard let row = compilations[safe: indexPath.section] else { return .init() }
            switch row.type {
            case .mini, .big, .promo, .bottles:
                // swiftlint:disable:next force_cast
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VinchySimpleConiniousCaruselCollectionCell.reuseId, for: indexPath) as! VinchySimpleConiniousCaruselCollectionCell
                cell.decorate(model: .init(type: row.type, collections: row.collectionList))
                cell.delegate = self
                return cell
            case .shareUs:
                // swiftlint:disable:next force_cast
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareUsCollectionCell.reuseId, for: indexPath) as! ShareUsCollectionCell
                cell.decorate(model: .init(titleText: localized("like_vinchy")))
                cell.delegate = self
                return cell
            case .smartFilter:
                // swiftlint:disable:next force_cast
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmartFilterCollectionCell.reuseId, for: indexPath) as! SmartFilterCollectionCell
                cell.decorate(model: .init(
                                accentText: "New in Vinchy".uppercased(),
                                boldText: "Personal compilations",
                                subtitleText: "Answer on 3 questions & we find for you best wines.",
                                buttonText: "Try now"))
                return cell
            case .infinity:
                switch collectionList[indexPath.row] {
                case .wine(let wine):
                    // swiftlint:disable:next force_cast
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as! WineCollectionViewCell
                    cell.highlightStyle = .scale
                    cell.decorate(model: .init(imageURL: wine.mainImageUrl?.toURL, titleText: wine.title, subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode), backgroundColor: .randomColor))
                    return cell

                case .ads(let ad):
                    // swiftlint:disable:next force_cast
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdsCollectionViewCell.reuseId, for: indexPath) as! AdsCollectionViewCell
                    if let ad = ad as? GADUnifiedNativeAd {
                        cell.adView.nativeAd = ad
                    }
                    return cell
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCollectionReusableView.reuseId,
                for: indexPath) as! HeaderCollectionReusableView // swiftlint:disable:this force_cast
            let title = compilations[safe: indexPath.section]?.title ?? ""
            header.decorate(model: .init(titleText: NSAttributedString(string: title, font: Font.heavy(20), textColor: .dark, paragraphAlignment: .left), insets: .init(top: 0, left: 20, bottom: 0, right: 20)))
            return header

        case UICollectionView.elementKindSectionFooter:
            if indexPath.section == compilations.count - 1 {

                let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: VinchyFooterCollectionReusableView.reuseId,
                    for: indexPath) as! VinchyFooterCollectionReusableView // swiftlint:disable:this force_cast
                let title = localized("harmful_to_your_health")
                footer.decorate(model: .init(titleText: NSAttributedString(string: title, font: Font.light(15), textColor: .blueGray, paragraphAlignment: .justified)))
                return footer
            }
            return .init()

        default:
            fatalError()
        }
    }
}

extension VinchyViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let resultsController = searchController.searchResultsController as? ResultsTableController {
            searchWorkItem.perform(after: 0.65) {
                guard searchText != "" else { return }
                Wines.shared.getWineBy(title: searchText, offset: 0, limit: 40) { result in
                    switch result {
                    case .success(let wines):
                        resultsController.didFoundProducts = wines
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let searchString = searchBar.text else {
            return
        }

        navigationController?.pushViewController(Assembly.buildShowcaseModule(navTitle: nil, mode: .advancedSearch(params: [("title", searchString)])), animated: true)
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
        if emailService.canSend && searchText != nil {
            let emailController = emailService.getEmailController(HTMLText: localized("email_did_not_find_wine") + (searchText ?? ""), recipients: [localized("contact_email")])
            present(emailController, animated: true, completion: nil)
        } else {
            showAlert(message: localized("open_mail_error"))
        }
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

//extension VinchyViewController: GADUnifiedNativeAdLoaderDelegate {
//
//    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
//        print(error)
//    }
//
//    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
//        if let lastObj = collectionList.last {
//            switch lastObj {
//            case .wine:
//                //collectionList.append(.ads(ad: nativeAd))
//                break
//            case .ads:
//                break
//            }
//        }
//    }
//}

extension VinchyViewController: VinchyViewControllerProtocol {
    
}

extension GADUnifiedNativeAd: AdsProtocol { }

extension VinchyViewController: ShareUsCollectionCellDelegate {
    func didTapShareUs(_ button: UIButton) {
        let items = [localized("i_use_vinchy"), openAppStoreURL]
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(controller, animated: true)
    }
}

//extension VinchyViewController: GADBannerViewDelegate {
//
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        bannerView.isHidden = false
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50 /*banner height*/, right: 0)
//    }
//
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        bannerView.isHidden = true
//        collectionView.contentInset = .zero
//        print(error)
//    }
//}

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

//extension MainViewController: VNDocumentCameraViewControllerDelegate {
//
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//
//        guard scan.pageCount >= 1 else {
//            controller.dismiss(animated: true)
//            return
//        }
//
//        processImage(scan.imageOfPage(at: 0))
//        controller.dismiss(animated: true)
//    }
//
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
//        controller.dismiss(animated: true)
//    }
//
//    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
//        controller.dismiss(animated: true)
//    }
//}

//        adBanner.isHidden = true
//        adBanner.adUnitID = "ca-app-pub-6194258101406763/1506612734" //"ca-app-pub-3940256099942544/2934735716"//"ca-app-pub-6194258101406763/1506612734"
//        adBanner.rootViewController = self
//        adBanner.delegate = self
//        adBanner.load(GADRequest())
//        adBanner.translatesAutoresizingMaskIntoConstraints = false

//        view.addSubview(adBanner)
//        positionBannerViewFullWidthAtBottomOfSafeArea(adBanner)

//    private func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
//        let guide = view.safeAreaLayoutGuide
//        NSLayoutConstraint.activate([
//            guide.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor),
//            guide.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor),
//            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
//        ])
//    }

//    private let adBanner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
