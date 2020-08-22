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
import JGProgressHUD
import CommonUI
import VinchyUI
import Core
import EmailService
import StringFormatting
import GoogleMobileAds

fileprivate let categoryHeaderID = "categoryHeaderID"
fileprivate let categoryFooterID = "categoryFooterID"

final class VinchyViewController: UIViewController, Alertable {

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let refreshControl = UIRefreshControl()
    private var searchController: UISearchController!
    private let resultsTableController = ResultsTableController()
    private let hud = JGProgressHUD(style: .dark)

    private let emailService = EmailService()
    private let adBanner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    private var searchText: String?

    private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
        guard let self = self else { return }
        self.hud.show(in: self.view, animated: true)
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

    private var compilations: [Compilation] = [] {
        didSet {
            loadViewIfNeeded()
            DispatchQueue.main.async {
                self.collectionView.collectionViewLayout = self.layout
                self.collectionView.reloadData()
            }
        }
    }

    private lazy var layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in

        var section: NSCollectionLayoutSection

        if self.isSearchingMode {
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), subitems: [item])
            section = NSCollectionLayoutSection(group: group)

        } else {
            switch self.compilations[sectionNumber].collectionList.first!.type {
            case .mini:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(135), heightDimension: .absolute(135)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section

            case .big:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(2/3), heightDimension: .absolute(155)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(35)), elementKind: categoryHeaderID, alignment: .topLeading)]
                return section

            case .promo:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(5/6), heightDimension: .absolute(120)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.orthogonalScrollingBehavior = .paging
                section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(35)), elementKind: categoryHeaderID, alignment: .topLeading)]
                return section

            case .bottles:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(250)), subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(35)), elementKind: categoryHeaderID, alignment: .topLeading)]
            }
        }

        if sectionNumber == self.compilations.count - 1 {
            section.boundarySupplementaryItems += [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: categoryFooterID, alignment: .bottom)]
        }

        return section
    }

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

        view.addSubview(collectionView)
        collectionView.frame = view.frame

        let filterBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(didTapFilter))

        navigationItem.rightBarButtonItems = [filterBarButtonItem]

        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.font = Font.medium(20)

        // TODO: - localize
        searchController.searchBar.searchTextField.layer.cornerRadius = 20
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        searchController.searchBar.searchTextField.layer.cornerCurve = .continuous

        resultsTableController.tableView.delegate = self
        resultsTableController.didnotFindTheWineTableCellDelegate = self

        navigationItem.searchController = searchController

        refreshControl.tintColor = .dark
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        adBanner.isHidden = true
        adBanner.adUnitID = "ca-app-pub-6194258101406763/1506612734" //"ca-app-pub-3940256099942544/2934735716"//"ca-app-pub-6194258101406763/1506612734"
        adBanner.rootViewController = self
        adBanner.delegate = self
        adBanner.load(GADRequest())
        adBanner.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(adBanner)
        positionBannerViewFullWidthAtBottomOfSafeArea(adBanner)

//        configureOCR()

        collectionView.backgroundColor = .mainBackground
        collectionView.register(StoryCollectionCell.self, WineCollectionViewCell.self, MainSubtitleCollectionCell.self, SuggestionCollectionCell.self)

        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: categoryHeaderID, withReuseIdentifier: HeaderCollectionReusableView.reuseId)

        collectionView.register(VinchyFooterCollectionReusableView.self, forSupplementaryViewOfKind: categoryFooterID, withReuseIdentifier: VinchyFooterCollectionReusableView.reuseId)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
    }

    @objc private func didTapFilter() {
        navigationController?.pushViewController(Assembly.buildFiltersModule(), animated: true)
    }

    private func fetchData() {
        Compilations.shared.getCompilations { [weak self] result in
            self?.dispatchWorkItemHud.cancel()
            DispatchQueue.main.async {
                self?.hud.dismiss(animated: false)
            }
            switch result {
            case .success(let model):
                self?.compilations = model
            case .failure(let error):
                self?.showAlert(message: error.message ?? "")
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

    @objc private func refresh() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.refreshControl.endRefreshing()
            }
        }
        collectionView.reloadData()
        CATransaction.commit()
    }

    private func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor),
            guide.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
        ])
    }

}

extension VinchyViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isSearchingMode {
            return 1
        } else {
            return compilations.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchingMode {
            return suggestions.count
        } else {
            switch compilations[section].collectionList.first!.type {
            case .mini:
                return compilations[section].collectionList.count
            case .big:
                return compilations[section].collectionList.count
            case .promo:
                return compilations[section].collectionList.count
            case .bottles:
                return compilations[section].collectionList.first?.wineList.count ?? 0
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if isSearchingMode {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCollectionCell.reuseId, for: indexPath) as! SuggestionCollectionCell
            cell.decorate(model: .init(title: suggestions[indexPath.row].title))
            return cell

        } else {
            guard let row = compilations[safe: indexPath.section] else { return .init() }

            switch row.collectionList.first!.type {
            case .mini:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionCell.reuseId, for: indexPath) as! StoryCollectionCell
                cell.decorate(model: .init(imageURL: row.collectionList[safe: indexPath.row]?.imageURL, title: row.collectionList[safe: indexPath.row]?.title))
                return cell

            case .big:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubtitleCollectionCell.reuseId, for: indexPath) as! MainSubtitleCollectionCell
                cell.decorate(model: .init(subtitle: row.collectionList[safe: indexPath.row]?.title, imageURL: row.collectionList[safe: indexPath.row]?.imageURL))
                return cell

            case .promo:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubtitleCollectionCell.reuseId, for: indexPath) as! MainSubtitleCollectionCell
                cell.decorate(model: .init(subtitle: row.collectionList[safe: indexPath.row]?.title, imageURL: row.collectionList[safe: indexPath.row]?.imageURL))
                return cell

            case .bottles:
                guard let collection = row.collectionList.first, let wine = collection.wineList[safe: indexPath.row] else { return .init()
                }

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as! WineCollectionViewCell
                cell.decorate(model: .init(imageURL: wine.mainImageUrl, title: wine.title, subtitle: nil))
                cell.background.backgroundColor = .option
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if isSearchingMode {
            guard let wineID = suggestions[safe: indexPath.row]?.id else { return }
            navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
        } else {
            guard let row = compilations[safe: indexPath.section] else { return }
            switch row.collectionList.first?.transition {
            case .detailCollection:
                navigationController?.pushViewController(Assembly.buildShowcaseModule(navTitle: row.collectionList[safe: indexPath.row]?.title, wines: row.collectionList[safe: indexPath.row]?.wineList ?? [], fromFilter: false), animated: true)
            case .detailWine:
                guard let wine = row.collectionList.first?.wineList[safe: indexPath.row] else { return }
                navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wine.id), animated: true)
            default:
                break
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == categoryFooterID {
            // TODO: - localize
            let title = "Чрезмерное употребление алкоголя\nвредит вашему здоровью"
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VinchyFooterCollectionReusableView.reuseId, for: indexPath) as! VinchyFooterCollectionReusableView
            footer.decorate(model: .init(title: NSAttributedString(string: title, font: Font.light(15), textColor: .blueGray, paragraphAlignment: .left)))
            return footer
        } else {
            let title = compilations[safe: indexPath.section]?.title
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reuseId, for: indexPath) as! HeaderCollectionReusableView
            header.decorate(model: .init(title: NSAttributedString(string: title ?? "", font: Font.heavy(20), textColor: .dark, paragraphAlignment: .left)))
            return header
        }
    }
}

extension VinchyViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let resultsController = searchController.searchResultsController as? ResultsTableController {
            searchWorkItem.perform(after: 0.65) {
                guard searchText != "" else { return }
                Wines.shared.getWineBy(title: searchText) { result in
                    switch result {
                    case .success(let wines):
                        resultsController.didFoundProducts = wines
                    case .failure(let error):
                        print(error.localizedDescription)
                        // TODO: - error show may be???
                        break
                    }
                }
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
        // TODO: - localize
        if emailService.canSend && searchText != nil {
            let emailController = emailService.getEmailController(HTMLText: "Привет я не нашел вино с названием " + (searchText ?? ""), recipients: [localized("contact_email")])
            present(emailController, animated: true, completion: nil)
        } else {
            showAlert(message: "Возникла ошибка при открытии почты")
        }
    }
}

extension VinchyViewController: GADBannerViewDelegate {

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50 /*banner height*/, right: 0)
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
        collectionView.contentInset = .zero
        print(error)
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
