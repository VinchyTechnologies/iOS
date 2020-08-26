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

fileprivate struct ShortInfoModel {
    let title: String?
    let subtitle: String?
}

//fileprivate struct TipsModel {
//    let
//}

fileprivate enum Section {
    case gallery(urls: [String?])
    case title(text: String)
    case tool(price: String?, isLiked: Bool)
    case description(text: String)
    case shortInfo(info: [ShortInfoModel])
    case button(ButtonCollectionCellViewModel)
}

final class WineDetailViewController: UIViewController, Alertable {

    private let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)

    private let dataBase = Database<DBWine>()
    private let emailService = EmailService()

    private var wine: Wine? {
        didSet {
            loadViewIfNeeded()
            guard let wine = wine else { return }
            var sections: [Section] = []

            let arg1 = [String(wine.mainImageUrl)]
            let arg2 = [String(wine.labelImageUrl)]
            let imageURLs = (arg1 + arg2 + Array(wine.imageURLs)).map { (str) -> String? in
                str == "" ? nil : str
            }

            sections.append(.gallery(urls: imageURLs))
            sections.append(.title(text: wine.title))
            // TODO: - isLiked, currency
            sections.append(.tool(price: formatCurrencyAmount(wine.price, currency: "USD"), isLiked: true))

            if wine.desc != "" {
                sections.append(.description(text: wine.desc))
            }

            var shortDescriptions: [ShortInfoModel] = []

            // TODO: - All options
            if wine.year != 0 {
                shortDescriptions.append(.init(title: String(wine.year), subtitle: "Year"))
            }

            if !shortDescriptions.isEmpty {
                sections.append(.shortInfo(info: shortDescriptions))
            }

            sections.append(.button(.init(normalImage: UIImage(systemName: "heart.slash", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "heart.slash.fill", withConfiguration: imageConfig), title: NSAttributedString(string: "Dislike", font: .boldSystemFont(ofSize: 18), textColor: .dark), type: .dislike)))

            sections.append(.button(.init(normalImage: nil, selectedImage: nil, title: NSAttributedString(string: "Tell about error", font: .boldSystemFont(ofSize: 18), textColor: .dark), type: .reportAnError)))

            self.sections = sections
        }
    }

    private var sections: [Section] = [] {
        didSet {
            collectionView.collectionViewLayout = layout
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
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 15, leading: 20, bottom: 0, trailing: 20)
            return section
        case .tool:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 15, leading: 20, bottom: 0, trailing: 20)
            return section
        case .shortInfo:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(180), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(180), heightDimension: .absolute(100)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 15, leading: 20, bottom: 0, trailing: 20)
            return section
        case .button:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 15, leading: 20, bottom: 0, trailing: 20)
            return section
        }
        
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .mainBackground
        collectionView.dataSource = self
//        collectionView.delegate = self

        collectionView.register(GalleryCell.self, TextCollectionCell.self, ToolCollectionCell.self, ShortInfoCollectionCell.self, ButtonCollectionCell.self)
        return collectionView
    }()

    init(wineID: Int64) {
        super.init(nibName: nil, bundle: nil)

        loadWineInfo(wineID: wineID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig), style: .plain, target: self, action: #selector(didTapNotes))
        
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.frame = view.frame
    }

    private func loadWineInfo(wineID: Int64) {
        Wines.shared.getDetailWine(wineID: wineID) { [weak self] result in
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
        button.isSelected.toggle()
        guard let wine = wine else { return }
        if let dbWine = realm(path: .dislike).objects(DBWine.self).first(where: { $0.wineID == wine.id }) {
            dataBase.remove(object: dbWine, at: .dislike)
        } else {
            dataBase.add(object: DBWine(id: dataBase.incrementID(path: .dislike), wineID: wine.id, mainImageUrl: wine.mainImageUrl, title: wine.title), at: .dislike)
        }
    }

    private func didTapReportError() {
        guard let wine = wine else { return }
        if emailService.canSend {
            let vc = emailService.getEmailController(HTMLText: wine.title, recipients: [localized("contact_email")])
            navigationController?.present(vc, animated: true, completion: nil)
        } else {
            showAlert(message: "Возникла ошибка при открытии почты") // TODO: - Localize
        }
    }
}

extension WineDetailViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .gallery, .title, .tool, .description, .button:
            return 1
        case .shortInfo(let info):
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
            cell.decorate(model: .init(title: NSAttributedString(string: text, font: Font.heavy(20), textColor: .dark)))
            return cell
        case .tool(let price, let isLiked):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolCollectionCell.reuseId, for: indexPath) as! ToolCollectionCell
            cell.decorate(model: .init(price: price, isLiked: isLiked))
            return cell
        case .description(let text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
            cell.decorate(model: .init(title: NSAttributedString(string: text, font: Font.light(18), textColor: .dark)))
            return cell
        case .shortInfo(let info):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortInfoCollectionCell.reuseId, for: indexPath) as! ShortInfoCollectionCell
            let item = info[indexPath.row]
            let title = NSAttributedString(string: item.title ?? "", font: Font.with(size: 24, design: .round, traits: .bold), textColor: .dark)
            let subtitle = NSAttributedString(string: item.subtitle ?? "", font: Font.with(size: 18, design: .round, traits: .bold), textColor: .blueGray)
            cell.decorate(model: .init(title: title, subtitle: subtitle))
            return cell
        case .button(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionCell.reuseId, for: indexPath) as! ButtonCollectionCell
            cell.decorate(model: .init(normalImage: viewModel.normalImage, selectedImage: viewModel.selectedImage, title: viewModel.title, type: viewModel.type))
            // TODO: - isSaved
            cell.delegate = self
            return cell
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
