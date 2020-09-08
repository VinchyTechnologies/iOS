//
//  VinchySimpleConiniousCaruselCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 02.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyCore
import Display
import MagazineLayout
import StringFormatting
import CommonUI


protocol VinchySimpleConiniousCaruselCollectionCellDelegate: AnyObject {
    func didTapBootleCell(wineID: Int64)
    func didTapCompilationCell(wines: [Wine], title: String?)
}

struct VinchySimpleConiniousCaruselCollectionCellViewModel: ViewModelProtocol {

    fileprivate let type: CollectionType
    fileprivate let collections: [Collection]

    public init(type: CollectionType, collections: [Collection]) {
        self.type = type
        self.collections = collections
    }
}

final class VinchySimpleConiniousCaruselCollectionCell: MagazineLayoutCollectionViewCell, Reusable {

    weak var delegate: VinchySimpleConiniousCaruselCollectionCellDelegate?

    private var type: CollectionType!

    private var collections: [Collection] = [] {
        didSet {
            collectionView.collectionViewLayout = layout
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private lazy var layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, env) -> NSCollectionLayoutSection? in
        var section: NSCollectionLayoutSection

        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

        let width: NSCollectionLayoutDimension

        switch self.type.itemSize.width {
        case .absolute(let _width):
            width = .absolute(_width)
        case .dimension(let _width):
            width = .fractionalWidth(_width)
        }

        switch self.type {
        case .mini:
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: width, heightDimension: .fractionalHeight(1)), subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous

        case .big:
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: width, heightDimension: .fractionalHeight(1)), subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous

        case .promo:
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: width, heightDimension: .fractionalHeight(1)), subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging

        case .bottles:
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: width, heightDimension: .fractionalHeight(1)), subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.orthogonalScrollingBehavior = .continuous

        case .none, .shareUs, .infinity:
            return nil
        }

        section.contentInsets = .init(top: 0, leading: 10, bottom: 5, trailing: 0)
        return section
    }, configuration: UICollectionViewCompositionalLayoutConfiguration())

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StoryCollectionCell.self, WineCollectionViewCell.self, MainSubtitleCollectionCell.self)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension VinchySimpleConiniousCaruselCollectionCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch self.type {
        case .mini:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionCell.reuseId, for: indexPath) as! StoryCollectionCell
            cell.decorate(model: .init(imageURL: collections[safe: indexPath.row]?.imageURL?.toURL, titleText: collections[safe: indexPath.row]?.title))
            return cell

        case .big:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubtitleCollectionCell.reuseId, for: indexPath) as! MainSubtitleCollectionCell
            cell.decorate(model: .init(subtitleText: collections[safe: indexPath.row]?.title, imageURL: collections[safe: indexPath.row]?.imageURL?.toURL))
            return cell

        case .promo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubtitleCollectionCell.reuseId, for: indexPath) as! MainSubtitleCollectionCell
            cell.decorate(model: .init(subtitleText: collections[safe: indexPath.row]?.title, imageURL: collections[safe: indexPath.row]?.imageURL?.toURL))
            return cell

        case .bottles:
            
            guard let collection = collections.first, let collectionItem = collection.wineList[safe: indexPath.row] else {
                return .init()
            }

            switch collectionItem {
            case .wine(let wine):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as! WineCollectionViewCell
                cell.decorate(model: .init(imageURL: wine.mainImageUrl?.toURL, titleText: wine.title, subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode)))
                cell.background.backgroundColor = .option
                return cell
            case .ads:
                return .init()
            }

        case .none, .shareUs, .infinity:
            return .init()
        }
    }
}

extension VinchySimpleConiniousCaruselCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch type {
        case .mini, .big, .promo:
            delegate?.didTapCompilationCell(wines: collections[indexPath.row].wineList.compactMap({ (collectionItem) -> Wine? in
                switch collectionItem {
                case .wine(let wine):
                    return wine
                case .ads:
                    return nil
                }
            }), title: collections[indexPath.row].title)

        case .bottles:
            guard let collection = collections.first, let collectionItem = collection.wineList[safe: indexPath.row] else {
                return
            }
            switch collectionItem {
            case .wine(let wine):
                delegate?.didTapBootleCell(wineID: wine.id)
            case .ads:
                break
            }

        case .none, .shareUs, .infinity:
            break
        }
    }
}

extension VinchySimpleConiniousCaruselCollectionCell: Decoratable {

    typealias ViewModel = VinchySimpleConiniousCaruselCollectionCellViewModel

    func decorate(model: ViewModel) {
        self.type = model.type
        self.collections = model.collections
    }
}
