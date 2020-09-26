//
//  WineDetailViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 24.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import VinchyCore
import Database
import CommonUI
import StringFormatting
import EmailService
import GoogleMobileAds

fileprivate enum ShortInfoModel {
    case titleTextAndImage(imageName: String, titleText: String?)
    case titleTextAndSubtitleText(titleText: String?, subtitleText: String?)
}

fileprivate enum Section {
    case gallery(urls: [String?])
    case title(text: String)
    case tool(price: String?, isLiked: Bool)
    case description(text: String)
    case shortInfo(info: [ShortInfoModel])
    case list(info: [ShortInfoModel])
    case button(ButtonCollectionCellViewModel)
    case ad
}

final class WineDetailViewController: UIViewController, Alertable, Loadable {

    private(set) var loadingIndicator = ActivityIndicatorView()

    private let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)

    private let dataBase = Database<DBWine>()
    private let emailService = EmailService()

    private var wine: Wine? {
        didSet {
            loadViewIfNeeded()
            guard let wine = wine else { return }
            configureView(wine: wine)
        }
    }

    private var sections: [Section] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private lazy var layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
        switch self.sections[sectionNumber] {
        case .gallery:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section

        case .title, .description:
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

        case .shortInfo:
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
            section.contentInsets = .init(top: 20, leading: 20, bottom: 0, trailing: 20)
            return section
            
        case .ad:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 15, leading: 0, bottom: 0, trailing: 0)
            return section
        }
        
    }

    private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
        self?.addLoader()
        self?.startLoadingAnimation()
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .mainBackground
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(GalleryCell.self, TextCollectionCell.self, ToolCollectionCell.self, ShortInfoCollectionCell.self, ButtonCollectionCell.self, ImageOptionCollectionCell.self, TitleWithSubtitleInfoCollectionViewCell.self, BigAdCollectionCell.self)
        return collectionView
    }()

    init(wineID: Int64) {
        super.init(nibName: nil, bundle: nil)

        loadWineInfo(wineID: wineID)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dispatchWorkItemHud.perform()
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig), style: .plain, target: self, action: #selector(didTapNotes))
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.frame = view.frame
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 15, right: 0)
    }

    private func loadWineInfo(wineID: Int64) {
        Wines.shared.getDetailWine(wineID: wineID) { [weak self] result in
            self?.dispatchWorkItemHud.cancel()
            DispatchQueue.main.async {
                self?.stopLoadingAnimation()
            }
            switch result {
            case .success(let wine):
                self?.wine = wine
                
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }

    @objc private func didTapNotes() {

        guard let wine = wine else { return }
        let controller = WriteMessageController()

        if let note = realm(path: .notes).objects(Note.self).first(where: { $0.wineID == wine.id }) {
            controller.note = note
            controller.subject = note.title
            controller.body = note.fullReview
        } else {
            controller.wine = wine
        }

        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    private func didTapDislikeButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        guard let wine = wine else { return }
        if let dbWine = realm(path: .dislike).objects(DBWine.self).first(where: { $0.wineID == wine.id }) {
            dataBase.remove(object: dbWine, at: .dislike)
        } else {
            dataBase.add(object: DBWine(id: dataBase.incrementID(path: .dislike), wineID: wine.id, mainImageUrl: wine.mainImageUrl ?? "", title: wine.title), at: .dislike)
        }
    }

    private func didTapReportError() {
        guard let wine = wine else { return }
        if emailService.canSend {
            let vc = emailService.getEmailController(HTMLText: wine.title, recipients: [localized("contact_email")])
            navigationController?.present(vc, animated: true, completion: nil)
        } else {
            showAlert(message: localized("open_mail_error"))
        }
    }

    private func configureView(wine: Wine) {

        var sections: [Section] = []
        sections += buildCaruselImages(wine: wine)
        sections += [.title(text: wine.title)]
        sections += buildTool(wine: wine)
        sections += buildDescription(wine: wine)
        sections +=  buildGeneralInfo(wine: wine)

        let servingTipsSection = buildServingTips(wine: wine)
        if !servingTipsSection.isEmpty {
            sections += [.title(text: localized("serving_tips").firstLetterUppercased())] 
            sections += servingTipsSection
        }

        sections.append(.button(.init(normalImage: UIImage(systemName: "heart.slash", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "heart.slash.fill", withConfiguration: imageConfig), title: NSAttributedString(string: localized("unlike").firstLetterUppercased(), font: .boldSystemFont(ofSize: 18), textColor: .dark), type: .dislike)))

        sections.append(.button(.init(normalImage: nil, selectedImage: nil, title: NSAttributedString(string: localized("tell_about_error").firstLetterUppercased(), font: .boldSystemFont(ofSize: 18), textColor: .dark), type: .reportAnError)))

        sections += [.ad]

        self.sections = sections
    }

    private func buildCaruselImages(wine: Wine) -> [Section] {

        let arg1 = [String(wine.mainImageUrl ?? "")]
        let arg2 = [String(wine.labelImageUrl ?? "")]
        let imageURLs = (arg1 + arg2 + Array(wine.imageURLs ?? [])).map { (str) -> String? in
            str == "" ? nil : str
        }

        if !imageURLs.isEmpty {
            return [.gallery(urls: imageURLs)]
        } else {
            return []
        }
    }

    private func buildTool(wine: Wine) -> [Section] {
        let isFavourite = realm(path: .like).objects(DBWine.self).first(where: { $0.wineID == wine.id }) != nil
        // TODO: - currency
        return [.tool(price: formatCurrencyAmount(wine.price ?? 0, currency: "USD"), isLiked: isFavourite)]
    }

    private func buildDescription(wine: Wine) -> [Section] {
        if let desc = wine.desc, desc != "" {
            return [.description(text: desc)]
        } else {
            return []
        }
    }

    private func buildGeneralInfo(wine: Wine) -> [Section] {

        var shortDescriptions: [ShortInfoModel] = []

        // TODO: - All options

        if let color = wine.color {
            shortDescriptions.append(.titleTextAndSubtitleText(titleText: localized(color.rawValue).firstLetterUppercased(), subtitleText: localized("color").firstLetterUppercased()))
        }

        if let sugar = wine.sugar {
            shortDescriptions.append(.titleTextAndSubtitleText(titleText: localized(sugar.rawValue).firstLetterUppercased(), subtitleText: localized("sugar").firstLetterUppercased()))
        }

        if let country = countryNameFromLocaleCode(countryCode: wine.winery?.countryCode) {
            shortDescriptions.append(.titleTextAndSubtitleText(titleText: country, subtitleText: localized("country").firstLetterUppercased()))
        }

        if let year = wine.year, year != 0 {
            shortDescriptions.append(.titleTextAndSubtitleText(titleText: String(year), subtitleText: localized("vintage").firstLetterUppercased()))
        }

        if let alcoholPercent = wine.alcoholPercent {
            shortDescriptions.append(.titleTextAndSubtitleText(titleText: String(alcoholPercent) + "%", subtitleText: localized("alcohol").firstLetterUppercased()))
        }

        if !shortDescriptions.isEmpty {
            return [.list(info: shortDescriptions)]
        } else {
            return []
        }
    }

    private func buildServingTips(wine: Wine) -> [Section] {
        var servingTips = [ShortInfoModel]()

        if let servingTemperature = localizedTemperature(wine.servingTemperature) {
            servingTips.append(.titleTextAndSubtitleText(titleText: servingTemperature, subtitleText: localized("serving_temperature").firstLetterUppercased()))
        }

        if let dishes = wine.dishCompatibility, !dishes.isEmpty {
            dishes.forEach { (dish) in
                servingTips.append(.titleTextAndImage(imageName: dish.imageName, titleText: localized(dish.rawValue).firstLetterUppercased()))
            }
        }

        if !servingTips.isEmpty {
            return [.shortInfo(info: servingTips)]
        } else {
            return []
        }
    }
}

extension WineDetailViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .gallery, .title, .tool, .description, .button, .ad:
            return 1
        case .shortInfo(let info), .list(let info):
            return info.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .gallery(let urls):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseId, for: indexPath) as! GalleryCell
            cell.decorate(model: .init(urls: urls))
            return cell

        case .title(let text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
            cell.decorate(model: .init(titleText: NSAttributedString(string: text, font: Font.heavy(20), textColor: .dark)))
            return cell

        case .tool(let price, let isLiked):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolCollectionCell.reuseId, for: indexPath) as! ToolCollectionCell
            cell.decorate(model: .init(price: price, isLiked: isLiked))
            cell.delegate = self
            return cell

        case .description(let text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
            cell.decorate(model: .init(titleText: NSAttributedString(string: text, font: Font.light(18), textColor: .dark)))
            return cell

        case .list(let info):
            let item = info[indexPath.row]

            switch item {
            case .titleTextAndImage:
                return .init()

            case .titleTextAndSubtitleText(let titleText, let subtitleText):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleWithSubtitleInfoCollectionViewCell.reuseId, for: indexPath) as! TitleWithSubtitleInfoCollectionViewCell
                cell.decorate(model: .init(titleText: titleText, subtitleText: subtitleText))
                cell.backgroundColor = indexPath.row.isMultiple(of: 2) ? .option : .mainBackground
                return cell
            }

        case .shortInfo(let info):
            let item = info[indexPath.row]
            switch item {
            case .titleTextAndImage(let imageName, let titleText):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageOptionCollectionCell.reuseId, for: indexPath) as! ImageOptionCollectionCell
                cell.decorate(model: .init(imageName: imageName, titleText: titleText))
                return cell

            case .titleTextAndSubtitleText(let titleText, let subtitleText):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortInfoCollectionCell.reuseId, for: indexPath) as! ShortInfoCollectionCell
                let title = NSAttributedString(string: titleText ?? "", font: Font.with(size: 24, design: .round, traits: .bold), textColor: .dark)
                let subtitle = NSAttributedString(string: subtitleText ?? "", font: Font.with(size: 18, design: .round, traits: .bold), textColor: .blueGray)
                cell.decorate(model: .init(title: title, subtitle: subtitle))
                return cell
            }

        case .button(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionCell.reuseId, for: indexPath) as! ButtonCollectionCell
            cell.decorate(model: viewModel)
            let isDisliked = realm(path: .dislike).objects(DBWine.self).first(where: { $0.wineID == wine?.id }) != nil
            cell.button.isSelected = isDisliked
            cell.delegate = self
            return cell
            
        case .ad:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigAdCollectionCell.reuseId, for: indexPath) as! BigAdCollectionCell
            cell.adBanner.delegate = self
            cell.adBanner.adUnitID = "ca-app-pub-6194258101406763/5750190016"
            cell.adBanner.rootViewController = self
            cell.adBanner.load(GADRequest())
            return cell
        }
    }
}

extension WineDetailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 300 {
            navigationItem.title = wine?.title
        } else {
            navigationItem.title = nil
        }
    }
}

extension WineDetailViewController: ButtonCollectionCellDelegate {

    func didTapButtonCollectionCell(_ button: UIButton, type: ButtonCollectionCellType) {
        switch type {
        case .dislike:
            didTapDislikeButton(button)
        case .reportAnError:
            didTapReportError()
        }
    }
}

extension WineDetailViewController: ToolCollectionCellDelegate {

    func didTapShare(_ button: UIButton) {
        guard let wine = wine else { return }
        let items = [wine.title]
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(controller, animated: true)
    }

    func didTapLike(_ button: UIButton) {
        guard let wine = wine else { return }
        if let dbWine = realm(path: .like).objects(DBWine.self).first(where: { $0.wineID == wine.id }) {
            dataBase.remove(object: dbWine, at: .like)
        } else {
            dataBase.add(object: DBWine(id: dataBase.incrementID(path: .like), wineID: wine.id, mainImageUrl: wine.mainImageUrl ?? "", title: wine.title), at: .like)
        }
    }

    func didTapPrice(_ button: UIButton) { }

}

extension WineDetailViewController: GADBannerViewDelegate {

}
