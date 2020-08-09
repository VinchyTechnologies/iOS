//
//  MainViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 27.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import SwiftUI
import GoogleMobileAds
import Vision
import VisionKit
import Core
import Display
import CommonUI
import JGProgressHUD

protocol MainViewControllerCellDelegate: AnyObject {
    func didSelectCell(indexPath: IndexPath, itemIndexPath: IndexPath)
}

final class MainViewController: ASDKViewController<MainNode>, Alertable {

    lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
        guard let self = self else { return }
        self.hud.show(in: self.node.view, animated: true)
    }

    private let hud = JGProgressHUD(style: .dark)

    private var isSearchingMode: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.node.tableNode.reloadData()
            }
        }
    }

    private var suggestions: [Wine] = []

    private var compilations: [Compilation] = [] {
        didSet {
            loadViewIfNeeded()
            node.tableNode.reloadData()
        }
    }

    private let refreshControl = UIRefreshControl()
    private var searchController: UISearchController!
    let resultsTableController = ResultsTableController()

    private let adBanner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)

    // MARK: - Initializers

    override init() {
        let node = MainNode()
        super.init(node: node)
        fetchData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dispatchWorkItemHud.perform()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)

//        let cameraBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera", withConfiguration: imageConfig), style: .plain, target: self, action: #selector(didTapCamera))

        let filterBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(didTapFilter))

        navigationItem.rightBarButtonItems = [filterBarButtonItem]
//        navigationItem.leftBarButtonItems = [cameraBarButtonItem]


        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.font = Font.medium(20)
//        searchController.searchBar.searchTextField.attributedPlaceholder =
//            NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueGray])
        // TODO: - localize
//        searchController.searchBar.searchTextField.leftView?.tintColor = .blueGray
        searchController.searchBar.searchTextField.layer.cornerRadius = 20
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        searchController.searchBar.searchTextField.layer.cornerCurve = .continuous


        resultsTableController.tableView.delegate = self

        navigationItem.searchController = searchController

        refreshControl.tintColor = .dark
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        node.tableNode.dataSource = self
        node.tableNode.delegate = self
        node.tableNode.view.refreshControl = refreshControl


        adBanner.isHidden = true
        adBanner.adUnitID = "ca-app-pub-6194258101406763/1506612734" //"ca-app-pub-3940256099942544/2934735716"//"ca-app-pub-6194258101406763/1506612734"
        adBanner.rootViewController = self
        adBanner.delegate = self
        adBanner.load(GADRequest())
        adBanner.translatesAutoresizingMaskIntoConstraints = false

        node.tableNode.view.addSubview(adBanner)
        positionBannerViewFullWidthAtBottomOfSafeArea(adBanner)

        configureOCR()
    }

    private func fetchData() {
        Compilations.shared.getCompilations { [weak self] result in
            self?.dispatchWorkItemHud.cancel()
            self?.hud.dismiss(animated: false)
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

    private func configureOCR() {
        ocrRequest = VNRecognizeTextRequest { (request, error) in

            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            var textsArray = [String]()
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                textsArray.append(topCandidate.string)
            }

            DispatchQueue.main.async {
                print(textsArray)
            }
        }

        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US"]
        ocrRequest.usesLanguageCorrection = true
    }

    private func processImage(_ image: UIImage) {

        guard let cgImage = image.cgImage else { return }

        textRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.ocrRequest])
            } catch {
                print(error)
            }
        }
    }

    private func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor),
            guide.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
        ])
    }

    @objc private func refresh() {
        node.tableNode.reloadData {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.refreshControl.endRefreshing()
            }
        }
    }

    @objc private func didTapCamera() {
        if let window = view.window {
            let transition = CATransition()
            transition.duration = 0.35
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.layer.add(transition, forKey: kCATransition)

            let vc = VNDocumentCameraViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }
    }

    @objc private func didTapFilter() {
        navigationController?.pushViewController(Assembly.buildFiltersModule(), animated: true)
    }

}

extension MainViewController: ASTableDataSource {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if isSearchingMode {
            return suggestions.count
        } else {
            return compilations.count
        }
    }

    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {

        if isSearchingMode {
            // TODO: - Nice to have Search Cell
            let cell = ASTextCellNode()
            cell.text = suggestions[safe: indexPath.row]?.title
            cell.textAttributes = [
                NSAttributedString.Key.font: Font.bold(20),
                NSAttributedString.Key.foregroundColor: UIColor.blueGray]
            cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
            cell.textInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            cell.selectionStyle = .none
            return cell
        } else {
            guard let row = compilations[safe: indexPath.row] else { return ASCellNode() }
            switch row.collectionList.first!.type {
            case .mini:
                let cell = MainCellNode(row: .init(title: row.title, items: row.collectionList.map({ (collection) -> MainMiniNodeViewModel in
                    return .init(imageURL: collection.imageURL ?? "", title: collection.title ?? "")
                })))
                cell.delegate = self
                return cell

            case .big:
                let cell = MainBigCellNode(row: .init(title: row.title, items: row.collectionList.map({ (collection) -> MainBigNodeViewModel in
                    return .init(imageURL: collection.imageURL ?? "", title: collection.title ?? "")
                })))
                cell.delegate = self
                return cell

            case .promo:
                let cell = MainPromoCellNode(row: .init(title: row.title, items: row.collectionList.map({ (collection) -> MainPromoNodeViewModel in
                    return .init(imageURL: collection.imageURL ?? "", title: collection.title ?? "")
                })))
                cell.delegate = self
                return cell

            case .bottles:
                guard let collection = row.collectionList.first else { return .init() }
                let cell = MainWineCellNode(row: .init(title: row.title, wines: collection.wineList.map({ (wine) -> WineViewCellViewModel in
                    return .init(imageURL: wine.mainImageUrl, title: wine.title, subtitle: "")
                })))
                cell.delegate = self
                return cell
                
            }
        }
    }
}

extension MainViewController: ASTableDelegate, UITableViewDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {

        guard isSearchingMode else { return }

        let selectedProduct: Wine?

        selectedProduct = suggestions[safe: indexPath.row]

        guard let product = selectedProduct else {
            tableNode.deselectRow(at: indexPath, animated: false)
            return
        }

        navigationController?.pushViewController(Assembly.buildDetailModule(wine: product), animated: true)

        tableNode.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isSearchingMode else { return }

        let selectedProduct: Wine?

        // Check to see which table view cell was selected.
        selectedProduct = resultsTableController.didFoundProducts[safe: indexPath.row]

        guard let product = selectedProduct else {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }

        self.navigationController?.pushViewController(Assembly.buildDetailModule(wine: product), animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension MainViewController: MainViewControllerCellDelegate {
    func didSelectCell(indexPath: IndexPath, itemIndexPath: IndexPath) {
        let collection = compilations[safe: indexPath.row]?.collectionList[safe: itemIndexPath.row]
        searchController.isActive = false
        if collection?.transition == "detail_collection" {
            navigationController?.pushViewController(Assembly.buildShowcaseModule(navTitle: collection?.title, wines: collection?.wineList ?? [], fromFilter: false), animated: true)
        } else if collection?.transition == "detail_wine" {
            guard let wine = collection?.wineList[safe: itemIndexPath.row] else { return }
            self.navigationController?.pushViewController(Assembly.buildDetailModule(wine: wine), animated: true)
        }
    }
}

extension MainViewController: GADBannerViewDelegate {

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
        node.tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50 /*banner height*/, right: 0)
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
        node.tableNode.contentInset = .zero
        print(error)
    }
}

extension MainViewController: VNDocumentCameraViewControllerDelegate {

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {

        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }

        processImage(scan.imageOfPage(at: 0))
        controller.dismiss(animated: true)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}

extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        if let resultsController = searchController.searchResultsController as? ResultsTableController {
            resultsController.didFoundProducts = []
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
